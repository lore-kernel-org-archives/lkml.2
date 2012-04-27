Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2D0Gsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:48:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58100 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2D0Gso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:48:44 -0400
Message-ID: <4F9A413B.50704@gmail.com>
Date: Fri, 27 Apr 2012 14:48:27 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, rusty@rustcorp.com.au
Subject: Re: [RFC PATCH 0/8] backtrace/oops with source/line information
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 05:29 AM, Jason Wessel wrote:
>
> The key difference here is that you get the source line information in
> any kind of oops/panic/backtrace, including inside kernel modules.  Of
> course this comes at the expense of some memory you do not get to use
> because these tables have to get stored in a place that is accessible
> after a crash.  On a system with 4 gigs of ram however, the cost is
> nearly insignificant when you have to give up a few megs for the
> capability.  The idea is to make it a bit easier to just jump into a
> source tree without having to use any tools to decode the dump (which
> I know every kernel developer out there already has anwyay :-)

So is the vmlinux size, right?
