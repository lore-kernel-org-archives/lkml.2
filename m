Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2GQUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:55:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:7912 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2GQUzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123600403"
Date: Tue, 17 Jul 2012 22:12:42 +0100
From: Alan Cox <alan@linux.intel.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: dkline@redhat.com, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: gma500 opregion/power init order backtrace
Message-ID: <20120717221242.315f8dfe@bob.linux.org.uk>
In-Reply-To: <20120717192614.GB18229@zod.bos.redhat.com>
References: <20120717192614.GB18229@zod.bos.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm wondering if the gma_power_init call can be moved up before
> chip_setup is called.  Seems so, but I thought I would ping you to see
> if you've seen this already.

Fixed in the patches that went to Linus.

I don't have the ACPI backlight working on a lot of systems and don't
know why to be honest but the native backlight should work. Of course if
the acpi keys are plumbed into the ACPI backlight it's less useful 8)

Alan
