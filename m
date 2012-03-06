Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031069Ab2CFUkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:40:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031036Ab2CFUkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:40:00 -0500
Date: Tue, 6 Mar 2012 12:39:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Mark Salter <msalter@redhat.com>, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] mm: Fix task_nommu build regression in linux-next
Message-Id: <20120306123959.1921bcca.akpm@linux-foundation.org>
In-Reply-To: <1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
References: <1331045377.17099.2.camel@deneb.redhat.com>
	<1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 01:46:33 +0530
Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:

> Commit b7b2a0afacada237005068294cb0ccc49d32889e resulted in a build
> failure for nommu builds:

Bare git commit IDs aren't very useful, because the ID of a patch can
be different in different trees.  And in linux-next, the ID of a patch
can change over time.  This is why we like to refer to commits using the
formulation b7b2a0afacad ("procfs: mark thread stack correctly in
proc/<pid>/maps").

