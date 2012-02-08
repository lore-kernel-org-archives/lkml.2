Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2BHSMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2BHSMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:12:30 -0500
Date: Wed, 8 Feb 2012 19:12:22 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Andrew Vagin <avagin@gmail.com>
Cc: Pedro Alves <palves@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120208181222.GA12787@host2.jankratochvil.net>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
 <20120203162519.GB805@google.com>
 <4F2C0F13.70709@parallels.com>
 <20120203165132.GA5636@redhat.com>
 <4F31848A.9070406@redhat.com>
 <4F327B99.7020602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F327B99.7020602@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Feb 2012 14:41:45 +0100, Andrew Vagin wrote:
> I want to say, that when you have trouble with child_tid_address,
> you may want to get it.
> If the code is your, you may get it via prctl, but if it's not, what
> will you do?

GDB does PTRACE_ARCH_PRCTL (amd64-linux-nat.c) - without inserting any code
into the debuggee.  How it can be simplified more?


Jan
