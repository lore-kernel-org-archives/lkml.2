Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402Ab2DKXYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:24:02 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215Ab2DKXXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:55 -0400
Message-Id: <20120411231043.973442120@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Mattia Dongili <malattia@linux.it>,
        Dimitris N <ddarlac@gmail.com>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [ 50/59] acer-wmi: No wifi rfkill on Sony machines
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit 5719b81988f3c24ff694dc3a37e35b35630a3966 upstream.

The wireless rfkill should charged by sony-laptop but not acer-wmi.
So, add Sony's SNY5001 acpi device to blacklist in acer-wmi.

Tested on Sony Vaio

Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Mattia Dongili <malattia@linux.it>
Cc: Dimitris N <ddarlac@gmail.com>
Tested-by: Dimitris N <ddarlac@gmail.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -692,6 +692,7 @@ static const struct acpi_device_id norfk
 	{ "VPC2004", 0},
 	{ "IBM0068", 0},
 	{ "LEN0068", 0},
+	{ "SNY5001", 0},	/* sony-laptop in charge */
 	{ "", 0},
 };
 


