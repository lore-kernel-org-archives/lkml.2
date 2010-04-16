Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab0DPQ16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:27:58 -0400
Received: from av9-2-sn2.hy.skanova.net ([81.228.8.180]:43448 "EHLO
	av9-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab0DPQ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:27:57 -0400
Subject: [PATCH 0/2] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 18:27:54 +0200
Message-ID: <1271435274.11641.44.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow are two patches.

The first one adds the timberdale video-in driver to the media tree.

The second one adds it to the timberdale MFD driver.

The Kconfig of the media patch selects TIMB_DMA which is introduced
in the DMA tree, that's why I cc:d in Dan.

Samuel and Mauro hope you can support and solve the potential merge
issue between your two trees.

Thanks
--Richard

