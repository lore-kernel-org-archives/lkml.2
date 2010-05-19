Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0ESUbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:31:46 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:58891 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab0ESUbo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:3:1>);
	Wed, 19 May 2010 16:31:44 -0400
Message-Id: <4BF412640200005A000679FE@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 Beta 
Date: Wed, 19 May 2010 14:31:32 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "Tejun Heo" <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-next@vger.kernel.org>
Subject: Re: [PATCH 06/17] vbus: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
 <1269885165-18617-7-git-send-email-tj@kernel.org>
 <4BB2FF000200005A0006349E@soto.provo.novell.com>
 <20100520014225.e4343903.sfr@canb.auug.org.au> 
In-Reply-To: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 5/19/2010 at 12:56 PM, in message <4BF41843.61E : 90 : 47687>, Gregory
Haskins wrote: 
> >>> On 5/19/2010 at 11:42 AM, in message
> <20100520014225.e4343903.sfr@canb.auug.org.au>, Stephen Rothwell
> <sfr@canb.auug.org.au> wrote: 
>> Hi Gregory,
>> 
>> On Wed, 31 Mar 2010 05:51:28 -0600 "Gregory Haskins" <ghaskins@novell.com> 
>> wrote:
>>>
>>> >>> On 3/29/2010 at 01:52 PM, in message
>>> <1269885165-18617-7-git-send-email-tj@kernel.org>, Tejun Heo <tj@kernel.org>
>>> wrote: 
>>> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>>> > gfp.h or slab.h is included as necessary.
>>> > 
>>> > Signed-off-by: Tejun Heo <tj@kernel.org>
>>> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>>> > Cc: Gregory Haskins <ghaskins@novell.com>
>>> 
>>> Thanks Tejun,
>>> 
>>> Acked-by: Gregory Haskins <ghaskins@novell.com>
>>> 
>>> (will add to my tree)
>> 
>> It never made it as far as I can see ... maybe something equivalent went in.
> 
> Hi Steven,
> 
> I dropped the ball on this.  Will merge when I return from lunch.
> 
> -Greg

Pushed (and sorry for the name mis-spelling above, Stephen!)

-Greg


