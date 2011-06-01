Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab1FAT5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1FAT47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:56:59 -0400
Date: Wed, 1 Jun 2011 21:55:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 11/17] ptrace: implement PTRACE_SEIZE
Message-ID: <20110601195520.GA9695@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <1306710760-16440-12-git-send-email-tj@kernel.org> <20110601190117.GB6504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601190117.GB6504@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Oleg Nesterov wrote:
>
> On 05/30, Tejun Heo wrote:
> >
> > * If PTRACE_SEIZE'd, group stop uses PTRACE_EVENT_STOP trap which uses
> >   exit_code of (SIGTRAP | PTRACE_EVENT_STOP << 8) instead of the
> >   stopping signal number
>
> Hmm. May be it would be better to report stopping_signal | PTRACE_EVENT_STOP
> instead... I am not sure yet, but it seems this way we can avoid the
> PTRACE_GETSIGINFO changes. I'll try to explain later, when I finsh the
> reading.

Tomorrow. I do not see any problems, the whole series looks fine to me.
Except I have some minor concerns which I need to re-check and summarize.

Oleg.

