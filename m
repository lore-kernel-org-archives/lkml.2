Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab1EZOLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:11:38 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36360 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab1EZOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:11:37 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: chris@cnpbagwell.com
Subject: [PATCH] mmc: Enable MMC card reader for RICOH [1180:e823]
Date: Thu, 26 May 2011 09:11:17 -0500
Message-Id: <1306419078-2669-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chris,

Please consider the following patch that enables reading MMC cards
on RICOH [1180:e823]. This patch was tested on Lenovo X220. 

Thank you
Manoj Iyer
