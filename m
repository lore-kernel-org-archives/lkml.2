Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493Ab2CFPSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:18:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52583 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153Ab2CFPSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:18:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.220.229 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 6 Mar 2012 17:17:55 +0200
Message-ID: <CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com>
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 4:59 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> When booting my machine with maxcpus=1, it seems to be ignored with
> 3.3.0-rc3.  I know that 3.1.0-rc3 works fine, but I haven't had time to
> track it down any further than that.  I've attached the dmesg from my
> machine.  Let me know if there is any other information that would help
> in solving this.

[snip]

> Brought up 1 CPUs
> Total of 1 processors activated (4256.06 BogoMIPS).

Looks like it indeed brings up only one CPU, what's the problem there?
