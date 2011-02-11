Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1BKQ1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 11:27:45 -0500
Received: from mailout05.t-online.de ([194.25.134.82]:35386 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab1BKQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:27:43 -0500
Message-ID: <4D556367.5000202@t-online.de>
Date: Fri, 11 Feb 2011 17:27:19 +0100
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110209224006.GA11202@kroah.com> <4D551F76.1070303@t-online.de> <20110211152231.GB13487@kroah.com>
In-Reply-To: <20110211152231.GB13487@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: SgiIGQZOZhitU56EIytSwH3sy7hN69DFK5QMygnX68EuHp0l03AbFdAjPVZ6p2FwWp
X-TOI-MSGID: 2356c0dc-a133-4961-bc56-aaa65a5f2906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DMI data for Samsung N145P/N250P/N260P

Signed-off-by: Richard Schütz <r.schtz@t-online.de>
---

> Yes I can, but do you want to send it to me in a format that I can apply
> so you can get the proper authorship credit?

Of course, here it is.

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -592,6 +592,15 @@ static struct dmi_system_id __initdata s
  		},
  		.callback = dmi_check_cb,
  	},
+	{
+		.ident = "N145P/N250P/N260P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
+			DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
+		},
+		.callback = dmi_check_cb,
+	},
  	{ },
  };
  MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);

-- 
Regards,
Richard Schütz
