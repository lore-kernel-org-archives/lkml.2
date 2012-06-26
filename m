Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2FZVRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:17:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FZVRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:17:17 -0400
Message-ID: <1340745423.21991.88.camel@twins>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Stefan Bader <stefan.bader@canonical.com>, mingo@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 26 Jun 2012 23:17:03 +0200
In-Reply-To: <20120626201339.GU3869@google.com>
References: <1340364965.18025.71.camel@twins>
	 <4FE48A09.7050305@canonical.com> <1340718515.21991.83.camel@twins>
	 <20120626201339.GU3869@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 13:13 -0700, Tejun Heo wrote:
> 
> BTW your patch is whitespace broken.  Seems like QP encoded.
> 
Yeah, that's the 'best' (d)evolution can do these days :/ I've been ><
close to looking at the source of that thing again, but the last time
left me traumatized.

I guess I should file a bug, but that means dealing with bugzilla..
which is just about as bad as looking at its source.
