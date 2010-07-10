Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab0GJFrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 01:47:17 -0400
Received: from smtp1.bendigoit.com.au ([203.16.224.4]:37883 "EHLO
	smtp1.bendigoit.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0GJFrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 01:47:16 -0400
X-Greylist: delayed 1738 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jul 2010 01:47:16 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning tomemory hotplug in Xen
Date: Sat, 10 Jul 2010 15:17:57 +1000
Message-ID: <AEC6C66638C05B468B556EA548C1A77D01A0A5F4@trantor>
In-Reply-To: <20100709173455.GD8696@router-fw-old.local.net-space.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning tomemory hotplug in Xen
thread-index: AcsfjSRU8KtxIB9YSHqKaey5WGtJcwAYfofA
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl> <871vbdr4ey.fsf@basil.nowhere.org> <AEC6C66638C05B468B556EA548C1A77D01A0A57D@trantor> <20100709173455.GD8696@router-fw-old.local.net-space.pl>
From: "James Harper" <james.harper@bendigoit.com.au>
To: "Daniel Kiper" <dkiper@net-space.pl>
Cc: "Andi Kleen" <andi@firstfloor.org>, <jeremy@goop.org>,
       <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
X-Really-From-Bendigo-IT: magichashvalue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Jul 09, 2010 at 08:58:01AM +1000, James Harper wrote:
> > > While you can do that the value is not very large because you
> > > could just start the guests with more memory, but ballooned in
> > > the first place (so that they don't actually use it)
> >
> > I think hotplug is a better method for adding memory for Windows.
> 
> Maybe in the future I write somthing for Windows...
> 

For Windows, I believe you would need to emulate actual hotplug of
memory like a physical machine, using ACPI. It's only supported on
Enterprise versions of Windows too.

James
