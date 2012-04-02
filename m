Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2DBW2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:28:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42566 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2DBW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:28:39 -0400
Date: Mon, 2 Apr 2012 15:28:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tao Ma <tm@tao.ma>, axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Message-ID: <20120402222833.GB21017@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <4F7A1C8B.3010402@tao.ma>
 <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A2217.2030201@tao.ma>
 <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A261A.9000200@tao.ma>
 <20120402222504.GA2672@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402222504.GA2672@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 06:25:04PM -0400, Vivek Goyal wrote:
> On Tue, Apr 03, 2012 at 06:20:10AM +0800, Tao Ma wrote:
> 
> [..]
> > > Yeah, just add config and stat files prefixed with the name of the new
> > > blkcg policy.
> > OK, I will add a new config file for it.
> 
> Only if CFQ could be modified to add one iops mode, flippable through a
> sysfs tunable, things will be much simpler. You will not have to add a
> new IO scheduler, no new configuration/stat files in blkcg (which is
> already crowded now).
> 
> I don't think anybody has shown the code that why CFQ can't be modified
> to support iops mode.

I haven't looked at the code so it's just an imporession but if we're
talking about completely different scheduling policy - cfq is about
slicing disk service time and IIUC the new thing being talked about is
using iops as scheduling unit probably for devices where seeking isn't
extremely expensive, and it might not make much sense to mix them
together.

Thanks.

-- 
tejun
