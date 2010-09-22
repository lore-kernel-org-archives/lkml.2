Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0IVLgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:36:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0IVLf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:35:58 -0400
Date: Wed, 22 Sep 2010 13:35:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v2 1/1] trivial: usbhid: Formatting fix
In-Reply-To: <1285107512-6940-1-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1009221335250.26813@pobox.suse.cz>
References: <4C98F245.2000002@ru.mvista.com> <1285107512-6940-1-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Alan Ott wrote:

> Added blank line after declarations.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  drivers/hid/usbhid/hid-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index b729c02..ff90069 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -810,6 +810,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
>  	if (usbhid->urbout) {
>  		int actual_length;
>  		int skipped_report_id = 0;
> +
>  		if (buf[0] == 0x0) {
>  			/* Don't send the Report ID */
>  			buf++;

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
