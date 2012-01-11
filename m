Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2AKKsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:48:39 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35100 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2AKKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:48:37 -0500
Date: Wed, 11 Jan 2012 10:49:57 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, mtk.manpages@gmail.com,
        oleg@redhat.com
Subject: Re: [PATCH 1/1][V5] Add reboot_pid_ns to handle the reboot syscall
Message-ID: <20120111104957.GA1097@hallyn.com>
References: <1325754410-32600-1-git-send-email-daniel.lezcano@free.fr>
 <1325754410-32600-2-git-send-email-daniel.lezcano@free.fr>
 <20120105192954.GA16083@sergelap>
 <20120111102346.GB8504@peqn>
 <20120111024530.7b3607e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111024530.7b3607e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 11 Jan 2012 11:23:46 +0100 Serge Hallyn <serge.hallyn@canonical.com> wrote:
> 
> > > 
> > > The testcase in [PATCH 0/1] passed for me, and reboot from init_pid_ns
> > > works as usual.
> > > 
> > > Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
> > 
> > Hi Andrew,
> > 
> > Are you considering taking this patch into -mm?
> 
> I have it queued up to look at.  I'll do that I've merged the current
> lot into rc1 - if I were to merge new stuff before then I'd only
> confuse myself ;)

Thanks!

-serge
