Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1A1RuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:50:21 -0500
Received: from xenotime.net ([72.52.115.56]:60544 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751409Ab1A1RuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:50:19 -0500
Date: Fri, 28 Jan 2011 09:50:18 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: erazor_de@users.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Registering ioctl number for hid-roccat chardev
Message-Id: <20110128095018.19a258e8.rdunlap@xenotime.net>
In-Reply-To: <1296235910.9030.1.camel@neuromancer>
References: <1296235910.9030.1.camel@neuromancer>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 18:31:50 +0100 Stefan Achatz wrote:

> I'd like to add an ioctl to my already existing hid-roccat chardev
> so that clients can inquire the report size. This would be needed
> for planned enhancements.
> The header actually resides in drivers/hid/hid-roccat.h and it is
> planned to move and rename it to /include/linux/roccat.h along with
> the ioctl implementation.
> This patch is to register the number and development will begin as
> soon as my choice is found to be good.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  Documentation/ioctl/ioctl-number.txt |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 63ffd78..99cd8d9c 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -133,6 +133,7 @@ Code  Seq#(hex)	Include File		Comments
>  'H'	C0-DF	net/bluetooth/hidp/hidp.h	conflict!
>  'H'	C0-DF	net/bluetooth/cmtp/cmtp.h	conflict!
>  'H'	C0-DF	net/bluetooth/bnep/bnep.h	conflict!
> +'H'	F1	linux/roccat.h		<mailto:erazor_de@users.sourceforge.net>
>  'I'	all	linux/isdn.h		conflict!
>  'I'	00-0F	drivers/isdn/divert/isdn_divert.h	conflict!
>  'I'	40-4F	linux/mISDNif.h		conflict!
> -- 

This part is fine.  Just include this patch when you add the ioctl handling.

I can't find include/linux/roccat.h...  Where is it?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
