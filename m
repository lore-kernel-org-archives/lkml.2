Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1HOXbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:31:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:60363 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1HOXbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:31:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110815231156.GC6867@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu> <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu> <20110815184957.GA16588@redhat.com>
 <20110815225003.GB29942@somewhere> <20110815231156.GC6867@unix33.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Mon, 15 Aug 2011 16:31:01 -0700
X-Google-Sender-Auth: Pq719eYiR3RWRXATdfKYNqAYrUc
Message-ID: <CALdu-PBtcg=wYmyngANzNXw29VT4tbgfxR7pi4TZDRRryOjyxw@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: fix ordering of calls in cgroup_attach_proc
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        NeilBrown <neilb@suse.de>, paulmck@linux.vnet.ibm.com,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 4:11 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> Fix ordering of cgroup_task_migrate and attach_task in cgroup_attach_proc.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Paul Menage <paul@paulmenage.org>

BTW, I left Google at the end of last week - if it's not bouncing
already, menage@google.com isn't going to work for much longer. I'll
try to get a patch out to the maintainers files.

Paul
