Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1ATQwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:52:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62558 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1ATQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:52:48 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=chl3Z4zJB8kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=umSfIBqF0P9tJU2zMzoA:9 a=Xa5BjAj1KDbjCaywCQdSKTFSZDoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] khugepaged crashes on x86_32
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1295542013.12215.2755.camel@gandalf.stny.rr.com>
References: <1295542013.12215.2755.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 20 Jan 2011 11:52:45 -0500
Message-ID: <1295542365.12215.2762.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 11:46 -0500, Steven Rostedt wrote:

> I hit this bug with both v2.6.38-rc1 and with
> 
> HEAD == 12fcdba1b7ae8b25696433f420b775aeb556d89b

Note, this is not fully reproducible at every boot. To test manually, I
had to boot up a couple of times to trigger it. But it never took more
than 5 boots to do so. I test by just booting up and shutting down, it
may trigger with some use as well, but I did not try that.

-- Steve


