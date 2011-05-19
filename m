Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab1ESQ7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933550Ab1ESQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:59:51 -0400
Date: Thu, 19 May 2011 18:58:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110519165833.GA19418@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-11-git-send-email-tj@kernel.org> <20110519163246.GF17265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519163246.GF17265@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Oleg Nesterov wrote:
>
> On 05/16, Tejun Heo wrote:
> >
> > When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
> > is set, which triggers STOP trap but is sticky until the next
> > PTRACE_GETSIGINFO.
>
> I simply can't understand this patch. And the supposed API as it seen
> by the user-space.

I'm afraid I wasn't clear. I didn't mean the patch is bad, I only meant
that I got lost in details and I feel I'll ask more questions later.

Oleg.

