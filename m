Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab1LRBX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 20:23:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54498 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1LRBX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 20:23:26 -0500
MIME-Version: 1.0
In-Reply-To: <m1iplerglz.fsf@fess.ebiederm.org>
References: <1323917052-480-1-git-send-email-walken@google.com>
	<20111215141945.add405d5.akpm@linux-foundation.org>
	<CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
	<20111215144411.930dd860.akpm@linux-foundation.org>
	<m1iplerglz.fsf@fess.ebiederm.org>
Date: Sat, 17 Dec 2011 17:23:25 -0800
Message-ID: <CANN689GLCsHTf09Rf43MAitQdTkUcd3ykhoZgk86eQzE_PnXzg@mail.gmail.com>
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
From: Michel Lespinasse <walken@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 2:14 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Calling sysctl(2) is very rare.  I don't know if it actually happens
> anywhere with a modern userspace except in regression tests.
> Effectively we retain sysctl(2) because it doesn't take too much to
> maintain.

Agree, there is no good reason one would call sysctl() anymore.

> Michel what caused you to discover this bug?  If you are using
> sysctl(2) in production code I am a bit worried.

Well, somebody hit it :) To be honest, I'm not sure how they came to
do that. It wasn't in a datacenter setting.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
