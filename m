Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965184Ab2CGSuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:50:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965049Ab2CGSum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:50:42 -0500
Date: Wed, 7 Mar 2012 13:50:37 -0500
From: Jason Baron <jbaron@redhat.com>
To: Roland McGrath <mcgrathr@google.com>
Cc: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH 1/2] core dump: drop VM_ALWAYSDUMP flag
Message-ID: <20120307185035.GA2409@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
 <3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com>
 <CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:59:58AM -0800, Roland McGrath wrote:
> On Wed, Mar 7, 2012 at 9:00 AM, Jason Baron <jbaron@redhat.com> wrote:
> > +       if (vma_name) {
> > +               if ((strcmp(vma_name, "[vdso]") == 0) ||
> > +                   (strcmp(vma_name, "[vectors]") == 0) ||
> > +                   (strcmp(vma_name, "[vsyscall]") == 0))
> 
> That's just disgusting.

well, sure, we can provide an arch interface, for this check. I'm more
concerned with the general idea. If it seems ok, I can re-do this bit
with an arch interface.

Thanks,

-Jason
