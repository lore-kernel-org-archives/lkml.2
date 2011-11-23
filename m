Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1KWR3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:29:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59332 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1KWR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUa0heYrn-Bwttz1qnDh6pY7KSV=CYJBTE6qMQUcX_v1w@mail.gmail.com>
References: <20111123033850.GA11380@redhat.com>
	<CAM_iQpUa0heYrn-Bwttz1qnDh6pY7KSV=CYJBTE6qMQUcX_v1w@mail.gmail.com>
Date: Wed, 23 Nov 2011 09:29:21 -0800
Message-ID: <CAFQmdRaJUt2Es=9Xic6PSs5AvLHo6HHg6Bnf1GHB7yrZ0bzYdg@mail.gmail.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:29 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> Will the following untested patch fix this problem?

It will probably silence the warning, but it will reopen the race I
was trying to fix.

Havard
