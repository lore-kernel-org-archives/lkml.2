Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1HPJvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 05:51:55 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34543 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab1HPJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 05:51:52 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 05:51:52 EDT
X-ClientAddr: 85.127.21.201
Date: Tue, 16 Aug 2011 11:43:33 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jeff Brown <jeffbrown@android.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        rydberg@euromail.se, chatty@enac.fr, benjamin.tissoires@enac.fr
Subject: Re: [PATCH] hid-multitouch: Filter collections by application
 usage.
Message-ID: <20110816114333.03e1f465@absol.kitzblitz>
In-Reply-To: <1313451868-79836-1-git-send-email-jeffbrown@android.com>
References: <1313451868-79836-1-git-send-email-jeffbrown@android.com>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: p7G9fqwQ015056
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a nit below.

* jeffbrown@android.com:
(..)
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 58d0e7a..4ee21ac 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -213,6 +213,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	struct mt_class *cls = td->mtclass;
>  	__s32 quirks = cls->quirks;
>  
> +	/* Only map fields from TouchScreen or TouchPad collections.
> +         * We need to ignore fields that belong to other collections
   ^
> +         * such as Mouse that might have the same GenericDesktop usages. */
   ^
You might want to use tabs here instead of spaces.

Best regards,
Nicolas Kaiser
