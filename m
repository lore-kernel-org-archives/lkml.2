Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2C1OvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:51:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:12256 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2C1OvV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 28 Mar 2012 10:51:21 -0400
Message-Id: <4F7341BA020000780007B825@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 28 Mar 2012 15:52:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Konrad Rzeszutek Wilk" <konrad@darnok.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Jinsong Liu" <jinsong.liu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <20120324003111.GA11777@andromeda.dapyr.net>
 <DE8DF0795D48FD4CA783C40EC8292335105AAF@SHSMSX101.ccr.corp.intel.com>
 <20120326163558.GC10236@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233510CE6F@SHSMSX101.ccr.corp.intel.com>
 <4F732365020000780007B6A1@nat28.tlf.novell.com>
 <20120328142742.GD18161@phenom.dumpdata.com>
In-Reply-To: <20120328142742.GD18161@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.03.12 at 16:27, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Wed, Mar 28, 2012 at 01:42:45PM +0100, Jan Beulich wrote:
>> >>> On 28.03.12 at 12:48, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> > But just curious, what's the purpose and benefit of exposing mwait to dom0? 
> 
> 
> So that cstate.c can evaluate properly the deeper C-states and 
> xen-acpi-processor
> can upload them to the hypervisor.
> 
>> > I remember xen against doing so before.
>> 
>> And I don't recall anything having changed in that regard.
> 
> Jan, you Acked the patch in question: https://lkml.org/lkml/2012/2/24/129 

But that isn't a Xen patch. Xen isn't (and shouldn't be) exposing mwait.

Jan

