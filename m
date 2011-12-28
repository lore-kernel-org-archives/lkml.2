Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1L1NwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 08:52:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:64521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab1L1NwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 08:52:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="92251630"
Date: Wed, 28 Dec 2011 14:04:45 +0000
From: Alan Cox <alan@linux.intel.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] staging, gma500: Fix warning in power.c
Message-ID: <20111228140445.70c11f9c@bob.linux.org.uk>
In-Reply-To: <1324579605.19018.3.camel@localhost.localdomain>
References: <1324579605.19018.3.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 00:46:45 +0600
Rakib Mullick <rakib.mullick@gmail.com> wrote:

>  gma_resume_display() wants 'struct pci_dev *' as it's parameter, so
> lets pass dev->pdev instead of dev. Fixes the following warning.
> 
> drivers/staging/gma500/power.c: In function ‘gma_power_begin’:
> drivers/staging/gma500/power.c:269:3: warning: passing argument 1 of
> ‘gma_resume_display’ from incompatible pointer type
> drivers/staging/gma500/power.c:99:13: note: expected ‘struct pci_dev
> *’ but argument is of type ‘struct drm_device *’ 

This staging driver is now dead and replaced with
drivers/gpu/drm/gma500/. Thanks for the fix however

Alan
