Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2GWKUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:20:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:50670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2GWKUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:20:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183915828"
Date: Mon, 23 Jul 2012 11:37:18 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anisse Astier <anisse@astier.eu>
Cc: Josh Boyer <jwboyer@redhat.com>, kernel-team@fedoraproject.org,
        Dave Airlie <airlied@redhat.com>, dkline@redhat.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: gma500 opregion/power init order backtrace
Message-ID: <20120723113718.3422c3c9@bob.linux.org.uk>
In-Reply-To: <20120720172044.5ad38413@destiny.ordissimo>
References: <20120717192614.GB18229@zod.bos.redhat.com>
	<20120717221242.315f8dfe@bob.linux.org.uk>
	<20120720163247.19578db4@destiny.ordissimo>
	<20120720172044.5ad38413@destiny.ordissimo>
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

> What I meant is: although these keycodes are already sent by acpi
> driver code, is it up to userspace to figure out which backlight
> driver to use, or should the kernel modify brightness in psb-bl
> directly ?

I'm not sure how its all glued together. I need to find out some day !
