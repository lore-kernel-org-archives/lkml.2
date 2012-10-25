Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab2JYLKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab2JYLJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:09:58 -0400
Date: Thu, 25 Oct 2012 07:09:54 -0400
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pi futex oops in __lock_acquire
Message-ID: <20121025110954.GA24886@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20121018015312.GA29865@redhat.com>
 <507F9944.50505@kernel.dk>
 <20121019052136.GA30852@redhat.com>
 <1350650972.30157.34.camel@twins>
 <20121023195026.GA2872@redhat.com>
 <20121024202411.GA20597@redhat.com>
 <5088C397.3000501@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5088C397.3000501@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:44:07PM -0700, Darren Hart wrote:
 > 
 > 
 > On 10/24/2012 01:24 PM, Dave Jones wrote:
 > > I've been able to trigger this for the last week or so.
 > > Unclear whether this is a new bug, or my fuzzer got smarter, but I see the
 > > pi-futex code hasn't changed since the last time it found something..
 > > 
 > >  > BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
 > >
 > > It looks like we got all the way to lock_acquire with a NULL 'lock' somehow.
 > > 
 > > Darren, any idea how this could happen ?
 > 
 > I'm digging. Can you get trinity to provide the arguments it used that
 > trigger the crash? That might help hone in on the exact path.
 
Happens pretty quickly with -c futex for me. (30 seconds or so)

	Dave
