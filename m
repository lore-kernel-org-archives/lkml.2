Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2ACVEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:04:16 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42414 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283Ab2ACVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:03:45 -0500
X-Sasl-enc: hfQW6yeH/SktT3SA0bTq33UwofFju3eLWEmIrcFbRp/2 1325624624
Date: Tue, 3 Jan 2012 12:54:28 -0800
From: Greg KH <greg@kroah.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org
Subject: Re: [PATCH 5/6] memcg: fix broken boolen expression
Message-ID: <20120103205428.GB17131@kroah.com>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <1324695619-5537-5-git-send-email-kirill@shutemov.name>
 <20111226153138.0376bd66.kamezawa.hiroyu@jp.fujitsu.com>
 <20111226065724.GA13459@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111226065724.GA13459@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 08:57:24AM +0200, Kirill A. Shutemov wrote:
> On Mon, Dec 26, 2011 at 03:31:38PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Sat, 24 Dec 2011 05:00:18 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > 
> > > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > > 
> > > action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > 
> > maybe this should go stable..
> 
> CC stable@

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
