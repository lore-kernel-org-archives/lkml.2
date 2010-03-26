Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0CZNtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0CZNtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:49:07 -0400
Date: Fri, 26 Mar 2010 14:47:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Grzegorz Nosek <root@localdomain.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326134709.GB15790@redhat.com>
References: <20100321195044.GA23757@megiteam.pl> <20100323212834.GH20796@count0.beaverton.ibm.com> <20100325213356.GB20541@megiteam.pl> <20100326111131.GA8604@redhat.com> <20100326115357.GA3345@count0.beaverton.ibm.com> <20100326124522.GD17113@megiteam.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326124522.GD17113@megiteam.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Grzegorz Nosek wrote:
>
> Hmm, is there a good reason why strace does not use the data explicitly
> provided by the kernel but instead second-guesses it from syscall return
> values? I don't know anything about ptrace, really,

I know almost nothing too. But _iirc_, this all is even worse, strace
doesn't necessary gets the notification from do_fork(), at least
another quick grep shows it doesn't use PTRACE_O_TRACEFORK.

This is another reason why the change in do_fork() can't really help
right now.

Oleg.

