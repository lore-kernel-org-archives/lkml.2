Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2DBWZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab2DBWZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:25:12 -0400
Date: Mon, 2 Apr 2012 18:25:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Message-ID: <20120402222504.GA2672@redhat.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <4F7A1C8B.3010402@tao.ma>
 <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A2217.2030201@tao.ma>
 <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A261A.9000200@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7A261A.9000200@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 06:20:10AM +0800, Tao Ma wrote:

[..]
> > Yeah, just add config and stat files prefixed with the name of the new
> > blkcg policy.
> OK, I will add a new config file for it.

Only if CFQ could be modified to add one iops mode, flippable through a
sysfs tunable, things will be much simpler. You will not have to add a
new IO scheduler, no new configuration/stat files in blkcg (which is
already crowded now).

I don't think anybody has shown the code that why CFQ can't be modified
to support iops mode.

Thanks
Vivek
