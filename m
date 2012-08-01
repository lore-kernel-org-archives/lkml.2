Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2HAVyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 17:54:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2HAVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:54:13 -0400
Date: Wed, 1 Aug 2012 14:54:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Moved core dump functionality into its own file
Message-Id: <20120801145411.d51a50aa.akpm@linux-foundation.org>
In-Reply-To: <1343787840-2013-1-git-send-email-alex.page.kelly@gmail.com>
References: <1343787840-2013-1-git-send-email-alex.page.kelly@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012 19:23:59 -0700
Alex Kelly <alex.page.kelly@gmail.com> wrote:

> This was done in preparation for making core dump functionality optional.
> 
> The variable "suid_dumpable" and associated functions are left in fs/exec.c
> because they're used elsewhere, such as in ptrace.

This patch will need to be redone and retested against the very latest
kernel.  Please do that shortly after 3.6-rc1 is released and resend.

