Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0HCPYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:24:44 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:47159 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0HCPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:24:42 -0400
Subject: [PATCH 0/3 v2] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 17:18:03 +0200
Message-ID: <1280848684.19898.160.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow are three patches.

The first adds in a cached version of the DMA contiguous video buffers.

The second adds the timberdale video-in driver to the media tree.

The third adds it to the timberdale MFD driver.

Samuel and Mauro hope you can support and solve the potential merge
issue between your two trees.

Thanks
--Richard

