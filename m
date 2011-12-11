Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1LKPjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 10:39:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1LKPjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 10:39:37 -0500
Message-ID: <1323617950.4063.11.camel@lappy>
Subject: Re: [tip:tools/kvm] kvm tools: Add 'kvm sandbox'
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        penberg@cs.helsinki.fi, penberg@kernel.org, tglx@linutronix.de
Date: Sun, 11 Dec 2011 17:39:10 +0200
In-Reply-To: <tip-dfb7f58f43dab84882d206e8ff2b478a94357191@git.kernel.org>
References: <tip-dfb7f58f43dab84882d206e8ff2b478a94357191@git.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 07:32 -0800, tip-bot for Sasha Levin wrote:
> Commit-ID:  dfb7f58f43dab84882d206e8ff2b478a94357191
> Gitweb:     http://git.kernel.org/tip/dfb7f58f43dab84882d206e8ff2b478a94357191
> Author:     Sasha Levin <levinsasha928@gmail.com>
> AuthorDate: Mon, 5 Dec 2011 16:16:36 +0200
> Committer:  Pekka Enberg <penberg@kernel.org>
> CommitDate: Sun, 11 Dec 2011 11:15:51 +0200
> 
> kvm tools: Add 'kvm sandbox'
> 
> This patch adds 'kvm sandbox' which is a wrapper on top of 'kvm run' which
> allows the user to easily specify sandboxed command to run in a custom
> rootfs guest.
> 
> Example usage:
> 
> 	kvm sandbox -d test_guest -k some_kernel -- do_something_in_guest

Maybe to make it clearer, the '-d' and '-k' are optional, not required.

For example, to do my trinity tests, I simply run:

	./kvm sandbox -- /trinity/trinity --mode=random -i

-- 

Sasha.

