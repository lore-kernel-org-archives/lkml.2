Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203Ab2LFPtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:49:12 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35620 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161Ab2LFPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:49:10 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: RFC: ARM HLCD: Add support for HDLCD device driver
Date: Thu,  6 Dec 2012 15:48:42 +0000
Message-Id: <1354808923-7416-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 06 Dec 2012 15:49:06.0573 (UTC) FILETIME=[393BF3D0:01CDD3C9]
X-MC-Unique: 112120615490728201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qB6FnHWV020431


Hello,

This is an initial attempt to add support for ARM's HDLCD device into
the mainline kernel. This code has been in use by Linaro for a while
and now it's time to push it into mainline as more people will have
access to the CoreTiles that support the device.

This patch is sent as an RFC as I am new to the whole submission
process in the kernel and would like to gather feedback first.

Thanks,
Liviu

