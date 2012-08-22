Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2HVWqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:46:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab2HVWqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:46:10 -0400
Date: Thu, 23 Aug 2012 00:46:03 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 19/36] autonuma: memory follows CPU algorithm and
 task/mm_autonuma stats collection
Message-ID: <20120822224603.GH8107@redhat.com>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
 <1345647560-30387-20-git-send-email-aarcange@redhat.com>
 <m2sjbe7k93.fsf@firstfloor.org>
 <20120822212459.GC8107@redhat.com>
 <20120822223733.GQ16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822223733.GQ16230@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, Aug 23, 2012 at 12:37:33AM +0200, Andi Kleen wrote:
> > 
> > This comment seems quite accurate to me (btw I taken it from
> > sched-numa rewrite with minor changes).
> 
> I had expected it to describe the next function. If it's a strategic
> overview maybe it should be somewhere else.

Well the next function is last_nid_set, and that's where the last_nid
logic is implemented. The comment explains why last_nid statistically
provides a benefit so I thought it was an ok location, but I welcome
suggestions to move it somewhere else.

Thanks,
Andrea
