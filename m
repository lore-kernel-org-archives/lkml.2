Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab1CaTuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:50:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53531 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab1CaTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:50:36 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, pingc@wacom.com, chris@cnpbagwell.com
Subject: [PATCH V2] add support for Lenovo tablet ID (0xE6)
Date: Thu, 31 Mar 2011 14:50:03 -0500
Message-Id: <1301601004-5391-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



As per Ping's comments, I have based this patch on Dmitry Torokhov's
for-linus tree. I have based it on entries for 0xE3, and added X,Y 
values from the tablet. 


