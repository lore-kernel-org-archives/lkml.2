Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937Ab0KQQZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:25:32 -0500
Received: from jdl.com ([208.123.74.7]:48533 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210Ab0KQQZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:25:31 -0500
X-Greylist: delayed 2250 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 11:25:30 EST
To: Grant Likely <grant.likely@secretlab.ca>
cc: John Bonesio <bones@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Subject: Re: [PATCH 1/5] scripts: dtc: Merge in changes from the dtc repository 
In-reply-to: <20101117045935.GA12084@angua.secretlab.ca> 
References: <20101116204917.12146.39851.stgit@riker> <20101116204951.12146.21084.stgit@riker> <20101117045935.GA12084@angua.secretlab.ca>
Comments: In-reply-to Grant Likely <grant.likely@secretlab.ca>
   message dated "Tue, 16 Nov 2010 21:59:35 -0700."
Date: Wed, 17 Nov 2010 09:47:55 -0600
From: Jon Loeliger <jdl@jdl.com>
Message-Id: <E1PIkEl-0006Zt-W7@jdl.com>
X-Spam-Score: -1.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 16, 2010 at 12:49:51PM -0800, John Bonesio wrote:
> > Pull in recent changes from the main dtc repository. These changes primarily
> > allow multiple device trees to be declared which are merged by dtc. This
> > feature allows us to include a basic dts file and then provide more informatio
> n
> > for the specific system through the merging functionality.
> > 
> > Signed-off-by: John Bonesio <bones@secretlab.ca>
> 
> Jon & David, I'll need your input on whether or not this is the best
> way to handle updating the dtc copy in the kernel tree.
> 
> g.

Grant,

Yeah, I wondered too. :-)  David added it and updated
in the kernel last round, so he may have some good notion
of what would be best there.

jdl
