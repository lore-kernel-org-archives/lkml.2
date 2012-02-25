Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2BYP0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 10:26:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46440 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab2BYP0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 10:26:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sshtylyov@mvista.com designates 10.204.128.132 as permitted sender) smtp.mail=sshtylyov@mvista.com
Message-ID: <4F48FD62.7090304@mvista.com>
Date: Sat, 25 Feb 2012 19:25:22 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: balbi@ti.com, dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] amd5536udc: fix type of ep_string.
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com> <1330132502-17057-6-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1330132502-17057-6-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-02-2012 5:15, Cyril Roelandt wrote:

> Use "static const char *" instead of "static const char *const".

    You're doing exactly oppposite.

> Signed-off-by: Cyril Roelandt<tipecaml@gmail.com>
> ---
>   drivers/usb/gadget/amd5536udc.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index 3d563d0..16079bd 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -140,7 +140,7 @@ static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
>
>   /* endpoint names used for print */
>   static const char ep0_string[] = "ep0in";
> -static const char *ep_string[] = {
> +static const char *const ep_string[] = {
>   	ep0_string,
>   	"ep1in-int", "ep2in-bulk", "ep3in-bulk", "ep4in-bulk", "ep5in-bulk",
>   	"ep6in-bulk", "ep7in-bulk", "ep8in-bulk", "ep9in-bulk", "ep10in-bulk",

WBR, Sergei
