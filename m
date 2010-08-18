Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0HRQl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:41:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55624 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0HRQl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B2zjzvVIPArb4kWgpihpXNd7uPq1i/XsJqwoe3IsEOQhQfB4AFcIg7ZYrFK0+WsS1x
         FQkq2JKdRoD7PjpF8iqHvZcC0/nxEwPnIW/M+Ehhke5sSCONRZJle2zVxKT7ZMzKQ1P9
         BesK3IR1FMm2UzT2Ajyk0kvgFqLXm1l/FHPsw=
MIME-Version: 1.0
In-Reply-To: <20100818055045.GD5243@cr0.nay.redhat.com>
References: <20100817225256.4775.6641.stgit@warthog.procyon.org.uk>
	<20100818055045.GD5243@cr0.nay.redhat.com>
Date: Wed, 18 Aug 2010 09:41:55 -0700
Message-ID: <AANLkTik0q6rzcvC6WYLaRESB2hL=CVD9F9X4N3PZ=YGg@mail.gmail.com>
Subject: Re: [PATCH] Make do_execve() take a const filename pointer
From: Tony Luck <tony.luck@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        dhowells@redhat.com
Cc: torvalds@osdl.org, akpm@linux-foundation.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:50 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> This patch looks good for me,

Okay in principle to me too ... but you missed a couple of
sys_execve() declarations. I'll fix
up the one in arch/ia64/include/asm/unistd.h (it can just be deleted).

There is also an unchanged declaration in asm-generic/syscalls.h which
may need to be
investigated.

-Tony
