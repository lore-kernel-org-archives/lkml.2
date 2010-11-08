Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0KHNpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:45:36 -0500
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:60647 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0KHNpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:45:35 -0500
Subject: [PATCH 0/2 v4] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 14:45:33 +0100
Message-ID: <1289223933.23406.19.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow are two patches.

The first adds the timberdale video-in driver to the media tree.

The second adds it to the timberdale MFD driver.

Changes since last version:
* Updated according the API changed in 2.6.37.

As Samuel pointed out earlier the patch to timberdale should be trivial
so I hope Mauro can take the patches via his tree.

Thanks
--Richard

