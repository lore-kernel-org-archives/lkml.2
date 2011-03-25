Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1CYHgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:36:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45611 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab1CYHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ej/LdFU38MirGmE5G6Pxu4Yax97ya7E5/DiXRLiSuFgEVBXXzlSnaJj8k+Voavl609
         /2FLl1is196beaLAkXTxIATVRN1wN3gOAjGyCHlf7UdaAIY3fOqr8eCiAiS//vaJaOWa
         D80qONcQrTaZ8Ek/uzL4nEfFvwPvqyR9Jt6+c=
Date: Fri, 25 Mar 2011 00:35:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: sparse-keymap - report KEY_UNKNOWN for
 unknown scan codes
Message-ID: <20110325073554.GD2590@core.coreip.homeip.net>
References: <1300914823-9440-1-git-send-email-seth.forshee@canonical.com>
 <1300914823-9440-3-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300914823-9440-3-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, Mar 23, 2011 at 04:13:43PM -0500, Seth Forshee wrote:
>  
> +	/* Report an unknown key event as a debugging aid */
> +	unknown_ke.type = KE_KEY;
> +	unknown_ke.code = code;
> +	unknown_ke.keycode = KEY_UNKNOWN;
> +	sparse_keymap_report_entry(dev, &unknown_ke, value, autorelease);

I think it should not depend on autorelease but always automatically
release KEY_UNKNOWN.

Otherwise I think I'll apply both patches.

Thanks.

-- 
Dmitry
