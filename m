Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0K3UHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:07:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0K3UHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:07:14 -0500
Date: Tue, 30 Nov 2010 21:00:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
Subject: [PATCH 0/4] exec: unify compat/non-compat code
Message-ID: <20101130200016.GD11905@redhat.com>
References: <20101125140253.GA29371@redhat.com> <20101125193659.GA14510@redhat.com> <20101129093803.829F.A69D9226@jp.fujitsu.com> <20101129113357.GA30657@redhat.com> <20101129182332.GA21470@redhat.com> <20101130195456.GA11905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130195456.GA11905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(remove stable)

On 11/30, Oleg Nesterov wrote:
>
> I'll send the cleanups which unify compat/non-compat code on
> top of these fixes, this is not stable material.

On top of

	[PATCH 1/2] exec: make argv/envp memory visible to oom-killer
	[PATCH 2/2] exec: copy-and-paste the fixes into compat_do_execve() paths

Imho, execve code in fs/compat.c must die. It is very hard to
maintain this copy-and-paste horror.

Oleg.

