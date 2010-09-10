Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab0IJJ33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:29:29 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:51056 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0IJJ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:29:28 -0400
Subject: [PATCH 0/2 v2] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 11:29:26 +0200
Message-ID: <1284110966.14259.32.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow are two patches.

The first adds the timberdale video-in driver to the media tree.

The second adds it to the timberdale MFD driver.

As Mauro pointed out earlier the patch to timberdale should be trivial
so I hope Mauro can take the patches via his tree.

Thanks
--Richard


