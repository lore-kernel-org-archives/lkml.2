Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1K3J5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:57:37 -0500
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:49210 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500Ab1K3J5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:57:35 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: Enabling dynamic debug at module load
Date: Wed, 30 Nov 2011 09:57:29 +0000
User-Agent: KMail/1.13.7 (Linux/3.1.0-1.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, jim.cromie@gmail.com
References: <201111290947.03046.tvrtko.ursulin@onelan.co.uk> <20111129182916.GB6610@redhat.com>
In-Reply-To: <20111129182916.GB6610@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111300957.29417.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 Nov 2011 18:29:16 Jason Baron wrote:
> On Tue, Nov 29, 2011 at 09:47:03AM +0000, Tvrtko Ursulin wrote:
> > Hi Jason,
> > 
> > What happened to the proposed patch to enable dynamic debug lines at
> > module load time?
> > 
> > After hitting this problem when trying to figure out why w83627ehf does
> > not load I found that apparently there is no way to enable pr_debug's
> > called from its module_init and googling discovered this thread:
> > https://lkml.org/lkml/2010/5/26/192
> > 
> > Thanks,
> > 
> > Tvrtko
> 
> Hi Tvrtko,
> 
> Jim Cromie and I have been working on a set of patches to address this
> issue. I'm aware this is an important issue (And yes, it's taken far too
> long to address it). We are trying to post something shortly.

It's not a regular nuisance for me, I just spotted the flaw and wanted to bring 
it up in case it slipped form everyone radars. If it was actively bugging me I 
would be happy to offer a hand. This way it is good to know it's being worked 
on so thanks for letting us know.

Regards,

Tvrtko
