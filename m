Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0JJRpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:45:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51182 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0JJRpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:45:01 -0400
Date: Sun, 10 Oct 2010 19:44:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010174454.GA21681@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
 <20101010162257.GA1272@redhat.com>
 <20101010170151.GD28828@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010170151.GD28828@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 06:01:51PM +0100, Alasdair G Kergon wrote:
> On Sun, Oct 10, 2010 at 12:22:57PM -0400, Mike Snitzer wrote:
> > this out quite yet.  You have 4 patches yet you say conceptually there
> > are 2 distinct changes.
>  
> IOW should we end up with 2 bisectable patches here?
> 
> And the potentially-broken/poorly-performing stacked async should be
> explained in comments inline perhaps if we're choosing to ignore this
> apparent regression.

It's not broken AFAIK and it will not perform worse than the original
single thread work queue.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
