Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1C3Kml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:42:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:13948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab1C3Kmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:42:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,267,1299484800"; 
   d="scan'208";a="903499470"
Date: Wed, 30 Mar 2011 11:23:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] GMA500 updates
Message-ID: <20110330112357.3ce1ccb9@bob.linux.org.uk>
In-Reply-To: <20110330103556.GB29796@srcf.ucam.org>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
	<20110330103556.GB29796@srcf.ucam.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 11:35:56 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Mar 30, 2011 at 09:58:57AM +0100, Alan Cox wrote:
> > This set of patches tackles three basic things
> > 
> > - Add support for Moorestown (not yet usable as it needs a memory
> > allocator)
> 
> Is Moorestown known as GMA500 or GMA600? Is there some more generic
> name that would cover all of them?

GMA600 if I remember rightly

I'm not aware of a generic naming for them.
