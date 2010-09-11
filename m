Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0IKIuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:50:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51174 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0IKIuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:50:07 -0400
Date: Sat, 11 Sep 2010 10:50:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic
 constants
Message-ID: <20100911105001.72b73ce8@basil.nowhere.org>
In-Reply-To: <1284151027.402.123.camel@laptop>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284151027.402.123.camel@laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 22:37:07 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-09-10 at 10:51 +0800, Huang Ying wrote:
> > +       return inb(NMI_REASON_PORT);
> 
> I've always wondered, where is this magic stuff documented?

In the datasheet of the chipset. But sometimes you need
to dig deeper to get a global picture including all chipsets.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
