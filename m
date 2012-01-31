Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2AaO03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:26:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2AaO02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:26:28 -0500
Date: Tue, 31 Jan 2012 09:26:22 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120131142621.GA2136@zod.bos.redhat.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
 <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
 <20120125134947.GF13655@zod.bos.redhat.com>
 <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125231534.GL13655@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 06:15:35PM -0500, Josh Boyer wrote:
> On Wed, Jan 25, 2012 at 02:04:08PM -0800, Suresh Siddha wrote:
> > On Wed, 2012-01-25 at 08:49 -0500, Josh Boyer wrote:
> > > [    0.000000] IOAPIC[1]: apic_id 2, version 255, address 0xfec28000, GSI 24-279
> > 
> > This looks indeed like a bogus entry probably returning all 1's for
> > RTE's etc. Can you please send me a dmesg with "apic=verbose" boot
> > parameter?
> 
> Here you go:
> 
> https://bugzilla.redhat.com/attachment.cgi?id=557552

Was this helpful at all?  I've been watching lkml for a related patch
in case I was missed on CC but haven't seen anything as of yet.

josh
