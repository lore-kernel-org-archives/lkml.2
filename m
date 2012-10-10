Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab2JJXSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:18:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42334 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637Ab2JJXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:00:59 -0400
X-Sasl-enc: XiYv8OojdoP8o8xB96my/XBjranGW84R461e7sze8FeB 1349910058
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: =?UTF-8?q?=5B=20013/122=5D=20media=3A=20gspca=5Fpac7302=3A=20make=20red=20balance=20and=20blue=20balance=20controls=20work=20again?=
Date: Thu, 11 Oct 2012 07:52:59 +0900
Message-Id: <20121010225340.496383770@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Schäfer <fschaefer.oss@googlemail.com>

commit db43b9ca2f101d0945d043fa7d5ecd8f2da17fef upstream.

Fix a regression from kernel 3.4 which has been introduced with the conversion of the gspca driver to the v4l2 control framework.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/gspca/pac7302.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -616,7 +616,7 @@ static int sd_init_controls(struct gspca
 	sd->red_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_RED_BALANCE, 0, 3, 1, 1);
 	sd->blue_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
-					V4L2_CID_RED_BALANCE, 0, 3, 1, 1);
+					V4L2_CID_BLUE_BALANCE, 0, 3, 1, 1);
 
 	gspca_dev->autogain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_AUTOGAIN, 0, 1, 1, 1);


