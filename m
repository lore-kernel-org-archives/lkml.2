Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab2IEKVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:21:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36744 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2IEKVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:21:00 -0400
Subject: Re: [RFC 0/5] forced comounts for cgroups.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, lennart@poettering.net,
        kay.sievers@vrfy.org
In-Reply-To: <50471C0C.7050600@parallels.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
	 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
	 <5047074D.1030104@parallels.com>
	 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50470A87.1040701@parallels.com>
	 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50470EBF.9070109@parallels.com>
	 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1346835993.2600.9.camel@twins>
	 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50471782.6060800@parallels.com> <1346837209.2600.14.camel@twins>
	 <50471C0C.7050600@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 12:20:53 +0200
Message-ID: <1346840453.2461.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 13:31 +0400, Glauber Costa wrote:
> 
> You wouldn't have to do more than one hierarchy walks for that. What
> Tejun seems to want, is the ability to not have a particular controller
> at some point in the tree. But if they exist, they are always together. 

Right, but the accounting is very much tied to the control structures, I
suppose we could change that, but my jet-leg addled brain isn't seeing
anything particularly nice atm.

But I don't really see the point though, this kind of interface would
only ever work for the non-controlling and controlling controller
combination (confused yet ;-), and I don't think we have many of those.

I would really rather see a simplification of the entire cgroup
interface space as opposed to making it more complex. And adding this
subtree 'feature' only makes it more complex.

