Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2JJWx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39203 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419Ab2JJWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:16 -0400
X-Sasl-enc: MpwS4M/DFNFmt5u7Z5yU9BW2k2dI8xdKdk811RXbJ0XJ 1349909595
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: =?UTF-8?q?=5B=20010/133=5D=20media=3A=20gspca=5Fpac7302=3A=20add=20support=20for=20device=201ae7=3A2001=20Speedlink=20Snappy=20Microphone=20SL-6825-SBK?=
Date: Thu, 11 Oct 2012 07:50:36 +0900
Message-Id: <20121010224856.307457201@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Schäfer <fschaefer.oss@googlemail.com>

commit 97d2fbf501e3cf105ac957086c7e40e62e15cdf8 upstream.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/gspca/pac7302.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -978,6 +978,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x093a, 0x262a)},
 	{USB_DEVICE(0x093a, 0x262c)},
 	{USB_DEVICE(0x145f, 0x013c)},
+	{USB_DEVICE(0x1ae7, 0x2001)}, /* SpeedLink Snappy Mic SL-6825-SBK */
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);


