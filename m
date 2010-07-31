Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0GaJnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 05:43:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36832 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0GaJnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 05:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LFFBSk5JuuW9Sar2FKSEj+zVmQEN9KxVygiileFruZNcQJHqfeKdl1rGzgMo44c14G
         TxJZYlelkaxjZcT/NplfDGcCp27jVNMq9BZ9b3l4jQ4BWcGkmMJgmTBgbTDRLIF1752W
         GUQQvHffzw+11X/39qETCuF4iKzaY6kBNecu4=
Date: Sat, 31 Jul 2010 02:43:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Make keyboard.c match braille-only keyboards
Message-ID: <20100731094304.GA3533@core.coreip.homeip.net>
References: <20100730204117.GI4824@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100730204117.GI4824@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 10:41:18PM +0200, Samuel Thibault wrote:
> drivers/char/keyboard.c also handles braille keys, so it should also match
> braille-only keyboards.
> 

Applied to 'next', thanks Samuel.

-- 
Dmitry
