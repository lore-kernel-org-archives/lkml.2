Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0GHX3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:29:08 -0400
Received: from smtp2.bendigoit.com.au ([203.16.207.99]:35792 "EHLO
	smtp2.bendigoit.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0GHX3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:29:06 -0400
X-Greylist: delayed 1847 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 19:29:06 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning tomemory hotplug in Xen
Date: Fri, 9 Jul 2010 08:58:01 +1000
Message-ID: <AEC6C66638C05B468B556EA548C1A77D01A0A57D@trantor>
In-Reply-To: <871vbdr4ey.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning tomemory hotplug in Xen
thread-index: Acse7ZnGEvp5u2qiRaCAnuchp0A0NwAA1SWw
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl> <871vbdr4ey.fsf@basil.nowhere.org>
From: "James Harper" <james.harper@bendigoit.com.au>
To: "Andi Kleen" <andi@firstfloor.org>, "Daniel Kiper" <dkiper@net-space.pl>
Cc: <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
       <linux-kernel@vger.kernel.org>
X-Really-From-Bendigo-IT: magichashvalue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Daniel Kiper <dkiper@net-space.pl> writes:
> >
> > OK, let's go to details. When I was playing with Xen I saw that
> > ballooning does not give possibility to extend memory over boundary
> > declared at the start of system. Yes, I know that is by desing
however
> > I thought that it is a limitation which could by very annoing in
some
> > enviroments (I think especially about servers). That is why I
decided to
> > develop some code which remove that one. At the beggining I thought
> > that it should be replaced by memory hotplyg however after some test
> > and discussion with Jeremy we decided to link balooning (for memory
> > removal) with memory hotplug (for extending memory above boundary
> > declared at the startup of system). Additionaly, we decided to
implement
> > this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
> > HVM/i386,x86_64).
> 
> While you can do that the value is not very large because you
> could just start the guests with more memory, but ballooned in
> the first place (so that they don't actually use it)
> 

I think hotplug is a better method for adding memory for Windows.

James
