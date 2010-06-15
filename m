Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0FOQSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:18:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23804 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab0FOQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:18:40 -0400
Date: Tue, 15 Jun 2010 09:15:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: tytso@mit.edu
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk
Subject: [PATCH] SubmittingPatches: add more about patch descriptions
Message-Id: <20100615091558.fb01497d.randy.dunlap@oracle.com>
In-Reply-To: <20100615125302.GK6666@thunk.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<20100614145839.8ac7687a.akpm@linux-foundation.org>
	<4C16AA75.8030303@kernel.org>
	<20100614153545.51fe0338.akpm@linux-foundation.org>
	<4C16B085.3030707@kernel.org>
	<20100615125302.GK6666@thunk.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4C17A74C.019F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 08:53:02 -0400 tytso@mit.edu wrote:

> On Tue, Jun 15, 2010 at 12:43:17AM +0200, Tejun Heo wrote:
> > 
> > Well, basics of the whole thing didn't change all that much since the
> > first take and most people on cc list were cc'd on each take.  The
> > biggest reason I'm still carrying the whole patchset is due to the
> > scheduler changes.  The numbers are in the third take (which you can
> > follow the links to find out).  Anyways, I'll write up another summary
> > tomorrow.
> 
> It really helps if patch summaries are self contained and don't
> require a bunch of kernel developers who are trying to review things
> to have to do research and then figure out which links are the right
> ones to chase down.  It's also not reasonable to expect your reviewers
> to diff your patches to determine how much has changed and whether
> they should expect benchmarks run from months ago to still be
> applicable or not.
> 
> Many of us get literally hundreds of e-mail messages a day, and
> e-mails are read with one finger hovering over the the 'd' key.  It
> simply scales better if you don't assume that everybody else considers
> the patch as important as you do, and instead assume that most people
> have forgotten patches sent months ago....  

Ack that.

Does this help?  anything need to be added to it?

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Add more information about patch descriptions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmittingPatches |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- lnx-2635-rc3.orig/Documentation/SubmittingPatches
+++ lnx-2635-rc3/Documentation/SubmittingPatches
@@ -98,6 +98,17 @@ system, git, as a "commit log".  See #15
 If your description starts to get long, that's a sign that you probably
 need to split up your patch.  See #3, next.
 
+When you submit or resubmit a patch or patch series, include the
+complete patch description and justification for it.  Don't just
+say that this is version N of the patch (series).  Don't expect the
+patch merger to refer back to earlier patch versions or referenced
+URLs to find the patch description and put that into the patch.
+I.e., the patch (series) and its description should be self-contained.
+This benefits both the patch merger(s) and reviewers.  Some reviewers
+probably didn't even receive earlier versions of the patch.
+
+If the patch fixes a logged bug entry, refer to that bug entry by
+number and URL.
 
 
 3) Separate your changes.
