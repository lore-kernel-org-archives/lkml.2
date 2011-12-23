Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1LWJru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:47:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab1LWJrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:47:47 -0500
Date: Fri, 23 Dec 2011 10:47:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
In-Reply-To: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1112231047000.21599@twin.jikos.cz>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011, Gaurav Saxena wrote:

> I am writing an application for which I need to intercept some
> filesystem system calls eg. unlink. I need unlink to call my code
> before deleting abc so that I could probably prevent unlink . I would
> like to implement this in a kernel module instead of modifying kernel
> code itself. I would like to intercept system calls by replacing
> system calls but I have not been able to find any method of doing that
> in linux > 3.0. Please suggest some method of doing that.

Write a kernel module that instruments sys_unlink() via krpobes. See 
Documentation/kprobes.txt for details.

-- 
Jiri Kosina
SUSE Labs

