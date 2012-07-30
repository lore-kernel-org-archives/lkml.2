Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2G3QFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:05:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56828 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3QFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120730082849.GF4025@dhcp-172-17-9-228.mtv.corp.google.com>
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
	<20120730082849.GF4025@dhcp-172-17-9-228.mtv.corp.google.com>
Date: Mon, 30 Jul 2012 09:05:40 -0700
Message-ID: <CALjC5hbLoco9D=iyj5Fi3Q2UowtMv+Ams_t5u4uX=vEyAiSbeQ@mail.gmail.com>
Subject: Re: crash in ocfs2_fast_symlink_readpage in kernel 3.5.0
From: Bret Towe <magnade@gmail.com>
To: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 1:28 AM, Joel Becker <jlbec@evilplan.org> wrote:
> On Sun, Jul 22, 2012 at 01:16:21PM -0700, Bret Towe wrote:
>> just booted a fresh 3.5 kernel and got the following on login via gdm
>> on the client computer
>> didn't see any crashes yet on any other computer but didn't give it
>> long to try after seeing this
>> let me know if you need more info
>> this client is running debian wheezy 64bit
>
> This is a different stack trace than another recent report.  Quick
> question: have you run 3.4 on this system?

been running it for a while now currently got 3.4.7 and 3.4.6
on the 2 systems that would likely see that bug (since its a gnome app
triggering it)
and they are both stable and show no issues
