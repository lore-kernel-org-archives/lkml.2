Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1JKHgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:36:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:65217 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1JKHgh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:6:1>);
	Tue, 11 Oct 2011 03:36:37 -0400
Message-Id: <4E940E21020000780005AA29@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 11 Oct 2011 08:36:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Dong Yang Li" <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance
	 discard support with secure erasing support.
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
 <20111010195749.GA5755@phenom.oracle.com>
In-Reply-To: <20111010195749.GA5755@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.10.11 at 21:57, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Oct 10, 2011 at 08:20:02PM +0100, Ian Campbell wrote:
>> On Mon, 2011-10-10 at 17:42 +0100, Konrad Rzeszutek Wilk wrote:
>> > On Mon, Oct 10, 2011 at 05:13:07PM +0100, Ian Campbell wrote:
>> 
>> > > In any case it should also be posted against the canonical inter-guest
>> > > interface definition in the xen tree for review with that in mind.
>> > 
>> > Yes! But I was thinking to first let this one rattle a bit and see what
>> > folks thought about it before submitting the xen-devel.
>> 
>> It's a good idea to get ABI changes out for review before the
>> implementation rattles around so much that changing it becomes hard.
> 
> OK, lets drop this until we get that straigthen out. I've posted
> http://lists.xensource.com/archives/html/xen-devel/2011-10/msg00642.html the 
> changes to
> Xen ABI.

Yeah, but that didn't get adjusted after IanC's comments (structure
alignment, BLKIF_OP_DISCARD_FLAG_SECURE value).

Further I wonder why you don't use the "reserved" field instead of
extending the structure at the end.

Jan

