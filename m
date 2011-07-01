Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1GAH4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:56:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:31919 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab1GAH4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:56:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="22661712"
Date: Fri, 1 Jul 2011 08:56:04 +0100
From: Alan Cox <alan@linux.intel.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
Message-ID: <20110701085604.0aabd6f1@bob.linux.org.uk>
In-Reply-To: <1309486707-1658-11-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slave devices all appear to be generic i2c interface hardware. I
don't see why they are separate special slave devices to your driver,
they should simply be i²c drivers so they can be used when those
devices are found without the mpu3050.

Alan
