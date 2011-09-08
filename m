Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1IHXeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab1IHXdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:33:54 -0400
Date: Thu, 8 Sep 2011 20:37:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify PTRACE_foo constants and PTRACE_SETOPTIONS
	code
Message-ID: <20110908183708.GA28841@redhat.com>
References: <201109072336.37300.vda.linux@googlemail.com> <20110908000614.GA3987@mtj.dyndns.org> <CAK1hOcMmwbSuDA2g4Tt7EO6sqjq-n-URTnMbr7RszqkMcs5jEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcMmwbSuDA2g4Tt7EO6sqjq-n-URTnMbr7RszqkMcs5jEA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Denys Vlasenko wrote:
>
> On Thu, Sep 8, 2011 at 2:06 AM, Tejun Heo <tj@kernel.org> wrote:
> > And it would be great if it explains what the historical bug was and
> > what the intended behavior is.

ptrace_setoptions() always changes ->ptrace, even if it returns
-EINVAL later.

> I'd rather nuke the bug in a follow-up patch (by deleting this line).

Denys, I think it would be much better to send 1/2 which fixes this oddity.

And note that this patch is wrong, I'll comment v3.

Oleg.

