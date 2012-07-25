Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2GYQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:15:51 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56386 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab2GYQPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:15:50 -0400
Date: Wed, 25 Jul 2012 11:15:47 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Hugh Dickins <hughd@google.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@gmail.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2 v5][resend] tmpfs: interleave the starting node of
	/dev/shmem
Message-ID: <20120725161547.GA27993@gulag1.americas.sgi.com>
References: <1341845199-25677-1-git-send-email-nzimmer@sgi.com> <1341845199-25677-2-git-send-email-nzimmer@sgi.com> <1341845199-25677-3-git-send-email-nzimmer@sgi.com> <20120723105819.GA4455@mwanda> <500DA581.1020602@sgi.com> <alpine.LSU.2.00.1207242048580.9334@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207242048580.9334@eggly.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:38:21PM -0700, Hugh Dickins wrote:
> 
> I'm glad Andrew took out the stable Cc: 
Actually I did that.  I have a habit of thinking about performance issues as
bugs and that is not always the case.

> Please, what's wrong with the patch below, to replace the current
> two or three?  I don't have real NUMA myself: does it work?
Yes it works and spreads quite nicely. 

> Nathan, I've presumptuously put in your signoff, because
> you generally seemed happy to incorporate suggestions made.
I am always grateful for suggestions, advise, and help.

Nate

