Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab1LNT00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:26:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7113 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1LNT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:26:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Dec 2011 11:26:16 -0800
Subject: Re: [PATCH 1/5] drivers: power: Rename bq20z75 to sbs-battery
From: Rhyland Klein <rklein@nvidia.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <20111206174100.GA15449@srcf.ucam.org>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
	 <20111206174100.GA15449@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 11:26:06 -0800
Message-ID: <1323890766.8326.2.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 09:41 -0800, Matthew Garrett wrote:
> On Mon, Dec 05, 2011 at 03:58:03PM -0800, Rhyland Klein wrote:
> 
> > +config BATTERY_SBS
> > +        tristate "SBS Compliant gas gauge"
> 
> This could potentially be confusing with the ACPI SBS code - I guess the 
> long term ideal would be to merge them?
> 

That might be an avenue worth looking into. I suspect it might end up
more being a exercise of pulling out the commonality (SBS definition)
and then you end up with 2 simpler drivers which use SBS for whichever
bus/subsystem they want. I am not sure we would be able to fully combine
them further than that, but maybe.

-rhyland

