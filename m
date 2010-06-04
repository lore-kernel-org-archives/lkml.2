Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0FDBmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:42:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36380 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab0FDBl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlOfQAjk7mfC528JPBtZlvLbSR29N9smFEu1GiLf1ADvTBJmY6368/47tNsdw/ldY4
         JldLmTlv5usweK6h9cSlmVTNuHtrtzjssHLrExVMFZY15tHKbs3/qQGGnTanQhlczGZ1
         rYqat8NGcREnwaWQAhI9aIUMbD7eA+fpsJHxU=
MIME-Version: 1.0
In-Reply-To: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
Date: Fri, 4 Jun 2010 09:41:58 +0800
Message-ID: <AANLkTilX_Fbc_pR1jtgQJsvu7RbMfgyhJYCxqV725T18@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 7:36 AM,  <akpm@linux-foundation.org> wrote:
> The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
>
>   http://userweb.kernel.org/~akpm/mmotm/
>

Hi, intel_idle build fails:

drivers/idle/intel_idle.c: In function ‘intel_idle’:
drivers/idle/intel_idle.c:234: error: too few arguments to function ‘trace_power
_start’
make[2]: *** [drivers/idle/intel_idle.o] Error 1
make[1]: *** [drivers/idle] Error 2
make[1]: *** Waiting for unfinished jobs....

-- 
Regards
dave
