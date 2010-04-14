Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0DNXIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:08:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:9367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043Ab0DNXIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,208,1270450800"; 
   d="scan'208";a="509226352"
Date: Wed, 14 Apr 2010 23:35:54 +0100
From: Alan Cox <alan@linux.intel.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 2/4] isl29020: ambient light sensor
Message-ID: <20100414233554.3f020155@linux.intel.com>
In-Reply-To: <20100414224542.GX30807@buzzloop.caiaq.de>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125147.23181.5817.stgit@localhost.localdomain>
	<20100414224542.GX30807@buzzloop.caiaq.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would it be possible to make the existing driver for the ISL29003
> support the ISL29020 as well?

I dug the manuals out for these to take a look - the answer is they are
quite different chips. 

Alan
