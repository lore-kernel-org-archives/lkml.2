Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0JPQwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:52:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0JPQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RrB20hht6SWQrDUoTldzRBDPshrtjactZ/zQxpKl38L5EKbv1xwTHqnH/kpZo3gW3C
         0LFevkz1oddMl5wV6bvli5pn3tz2n+EffHangcM+08h47EmfeF0AX+yw/HfiTnvQn2um
         fDcaqCRjG7CtKw/WQgqnfJXHNviogTaSywl1U=
Message-ID: <4CB9D854.7050806@gmail.com>
Date: Sat, 16 Oct 2010 18:52:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
        mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/05] Drivers: char: impi: Makefile: replace the use
 of <module>-objs with <module>-y
References: <1287235613-1545-1-git-send-email-tdent48227@gmail.com> <1287235613-1545-2-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1287235613-1545-2-git-send-email-tdent48227@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2010 03:26 PM, Tracey Dent wrote:
> Changed <module>-objs to <module>-y in Makefile.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/char/ipmi/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/ipmi/Makefile b/drivers/char/ipmi/Makefile
> index eb8a1a8..16a9364 100644
> --- a/drivers/char/ipmi/Makefile
> +++ b/drivers/char/ipmi/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the ipmi drivers.
>  #
>  
> -ipmi_si-objs := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
> +ipmi_si-y := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o

NACK (and all of these). This will try to build 4 modules instead of
one. Read Documentation/kbuild/makefiles.txt

regards,
-- 
js
