Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1CLERc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 23:17:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1CLERa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 23:17:30 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=sZdbWpBRYIUA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=gxWeQ4YclKwJLGuVcPsA:9 a=ERfpNFgL2CNcw_GhXMTfSSdY5dsA:4 a=CjuIK1q_8ugA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 11 Mar 2011 23:17:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, vgoyal@redhat.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add unaccounted time to timeslice_used.
Message-ID: <20110312041729.GB15526@home.goodmis.org>
References: <1299877572-30353-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299877572-30353-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 01:06:12PM -0800, Justin TerAvest wrote:
> There are two kind of times that tasks are not charged for: the first
> seek and the extra time slice used over the allocated timeslice. Both
> of these exported as a new unaccounted_time stat.
> 
> I think it would be good to have this reported in 'time' as well, but
> that is probably a separate discussion.
> 
> Signed-off-by: Justin TerAvest <teravest@google.com>
> ---
>  block/blk-cgroup.c  |   16 +++++++++++++++-
>  block/blk-cgroup.h  |   12 ++++++++++--
>  block/cfq-iosched.c |   21 +++++++++++++--------
>  block/cfq.h         |    6 +++---
>  4 files changed, 41 insertions(+), 14 deletions(-)

Hi! Just an FYI, could you add what subsystem you are changing into the
subject. Like:

[PATCH] block: Add unaccounted time to timeslice_used

Otherwise, the subject looks like it's modifying the kernel internal time
source.

Thanks,

-- Steve

