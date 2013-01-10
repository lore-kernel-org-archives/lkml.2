Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3AJJIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:08:18 -0500
Received: from ozlabs.org ([203.10.76.45]:34474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab3AJJIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:08:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <sasha.levin@oracle.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rostedt@goodmis.org, fweisbec@gmail.com,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, jbaron@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 1/5] module: constify within_module_*
In-Reply-To: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 10 Jan 2013 19:32:27 +1030
Message-ID: <871udt2yxo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> These helper functions just check a set intersection with a range, and
> don't actually modify struct module.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks, applied.

Cheers,
Rusty.
