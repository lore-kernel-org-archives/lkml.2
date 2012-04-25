Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab2DYLvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:51:54 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53374 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab2DYLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:51:52 -0400
Message-ID: <4F97E550.4060208@gmail.com>
Date: Wed, 25 Apr 2012 19:51:44 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] compiler.h: introduce unused_expression() macro
References: <20120425112623.26927.43229.stgit@zurg>
In-Reply-To: <20120425112623.26927.43229.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 07:26 PM, Konstantin Khlebnikov wrote:
> Sometimes we want to check some expressions correctness in compile-time without
> generating extra code. "(void)(e)" does not work if expression has side-effects.
> This patch introduces macro unused_expression() which helps in this situation.
>

Interesting, I am wondering why gcc doesn't eliminate the code as we 
pass either -O2 or -Os to it.
