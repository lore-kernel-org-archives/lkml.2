Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab2JXJoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:44:39 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55417 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab2JXJoi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 24 Oct 2012 05:44:38 -0400
Message-Id: <5087D4A102000078000A3E23@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 24 Oct 2012 10:44:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>
Cc: "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V5] PVH patches for v3.8.
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
 <5087B13402000078000A3CBB@nat28.tlf.novell.com>
 <1351071279.2237.126.camel@zakaz.uk.xensource.com>
In-Reply-To: <1351071279.2237.126.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.10.12 at 11:34, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Wed, 2012-10-24 at 08:13 +0100, Jan Beulich wrote:
> 
>> >  include/xen/interface/memory.h       |   29 ++++++-
>> >  include/xen/interface/physdev.h      |   10 ++
>> 
>> ... any changes to the hypervisor interface (didn't look in detail
>> what is being changed in these two headers) should first be in
>> at least -unstable before being consumed in any official release
>> imo.
> 
> I'd also like to see at least the interface definitions in the h/v tree
> if not the implementation right away.
> 
> The flip side is that we have agreed that the interfaces are not
> considered set in stone / stable until we've had a chance to review the
> implementation, so perhaps it is better not to commit them to
> xen-unstable.hg right away.
> 
> I don't know what the right answer is. Perhaps we should at a minimum
> reserve the subop numbers even if we don't yet define what they mean in
> the Xen tree.

But even then - what use is it to have 3.8 possibly only work on
some intermediate (perhaps even just privately built) hypervisors?

Jan

