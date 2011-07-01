Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1GAH32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:29:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:22753 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab1GAH31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:29:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="21348945"
Date: Fri, 1 Jul 2011 08:29:19 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README
 file.
Message-ID: <20110701082919.45a68f7e@bob.linux.org.uk>
In-Reply-To: <20110701030904.GA3748@suse.de>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<20110701030904.GA3748@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Shouldn't you be using the iio subsystem for the kernel/user interface
> as I think it handles most of this for you already, right?

The input layer will for a general driver, in fact an mpu3050 driver
just went into the input layer although there are some other bits in
this one that perhaps will want adding to it.

Alan
