Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2KGSu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:50:28 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48016 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2KGSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:50:27 -0500
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Staging: winbond: wbusb: Fixed coding style issue
Date: Thu,  8 Nov 2012 00:19:59 +0530
Message-Id: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

winbond directory files have lots of coding style issues. 
The patch set tries to remove *most* (if not all) of the coding style issues. 
checkpatch.pl script can still complain but major part of the serious coding style issues have been rectified.

 

