Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab0JHRRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:17:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43343
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932433Ab0JHRRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:17:38 -0400
Date: Fri, 08 Oct 2010 10:17:59 -0700 (PDT)
Message-Id: <20101008.101759.193728130.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: dilinger@queued.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2 v2] of: move phandle/ihandle into types.h and
 export to userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101008171210.GE3863@angua.secretlab.ca>
References: <20101008004354.13b5b254@debxo>
	<20101008171210.GE3863@angua.secretlab.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Oct 2010 11:12:10 -0600

> On Fri, Oct 08, 2010 at 12:43:54AM -0700, Andres Salomon wrote:
>> 
>> We need phandle for some exported sparc headers; of.h isn't an
>> exported header, and it would be silly to export it when all we
>> really need is one or two types from it.  Also, later patches
>> use phandle in structs that are exported to userspace, so export
>> a __kernel_phandle type.
>> 
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Looks okay to me.  I'm build testing it now on powerpc and
> microblaze.  If davem agrees, then I'll pick it up into my
> devicetree-next branch.
> 
> Question though; since sparc userspace is the only user of this,
> should the types.h header avoid exposing it on non-sparc?

I can't think of anything in Sparc userspace that needs the
phandle_t type.

In fact I was a bit confused when you asked Andres to expose
it to userspace.

What I remember from a previous thread is that some other platforms
use the type in their DT device-tree building tools or whatever, but
they define phandle_t for themselves I remember specifically
mentioning sparc has no use for this currently.
