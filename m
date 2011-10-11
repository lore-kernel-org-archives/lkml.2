Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1JKPwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:52:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:62620 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1JKPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:52:04 -0400
Date: Tue, 11 Oct 2011 11:51:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dong Yang Li <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111011155133.GC29349@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
 <20111010195749.GA5755@phenom.oracle.com>
 <4E940E21020000780005AA29@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E940E21020000780005AA29@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E94661A.01F1:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:36:33AM +0100, Jan Beulich wrote:
> >>> On 10.10.11 at 21:57, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Mon, Oct 10, 2011 at 08:20:02PM +0100, Ian Campbell wrote:
> >> On Mon, 2011-10-10 at 17:42 +0100, Konrad Rzeszutek Wilk wrote:
> >> > On Mon, Oct 10, 2011 at 05:13:07PM +0100, Ian Campbell wrote:
> >> 
> >> > > In any case it should also be posted against the canonical inter-guest
> >> > > interface definition in the xen tree for review with that in mind.
> >> > 
> >> > Yes! But I was thinking to first let this one rattle a bit and see what
> >> > folks thought about it before submitting the xen-devel.
> >> 
> >> It's a good idea to get ABI changes out for review before the
> >> implementation rattles around so much that changing it becomes hard.
> > 
> > OK, lets drop this until we get that straigthen out. I've posted
> > http://lists.xensource.com/archives/html/xen-devel/2011-10/msg00642.html the 
> > changes to
> > Xen ABI.
> 
> Yeah, but that didn't get adjusted after IanC's comments (structure
> alignment, BLKIF_OP_DISCARD_FLAG_SECURE value).

My later response to it should include it:
http://lists.xensource.com/archives/html/xen-devel/2011-10/msg00652.html

> 
> Further I wonder why you don't use the "reserved" field instead of
> extending the structure at the end.

<blinks> I completly missed it. That would definitly work as well.

Let me redo it with that in mind.
