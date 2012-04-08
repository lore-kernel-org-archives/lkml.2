Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2DHAPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 20:15:07 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37761 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2DHAPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 20:15:05 -0400
References: <1333418527.2035.11.camel@shrek.rexursive.com> <201204030631.24974.rjw@sisk.pl> <1333432393.2035.13.camel@shrek.rexursive.com> <1333620908.8191.1.camel@shrek.rexursive.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1333620908.8191.1.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8]: Hibernation: lower/better control the amount of pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
Date: Sun, 08 Apr 2012 10:14:59 +1000
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Message-ID: <2cbc3801-3ab0-4ef6-84cd-d69a23ff4dcc@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bojan Smojver <bojan@rexursive.com> wrote:

>I just got confirmation that the patch indeed solves the hang problem
>in
>3.2 and page allocation errors in 3.3:
>
>https://bugzilla.redhat.com/show_bug.cgi?id=785384#c68
>
>Could you please queue it up for 3.4 and then stable.

Please ignore this request. As it turns out, the hangs are still there, it just takes a bit longer to trigger.

We must be leaking pages during hibernation somehow, although I cannot replicate this on my system. I think I will have to revert I/O improvements on image save for now or maybe replace then with a bit of async I/O in a separate thread to at least retain a bit of the performance gains.

Will keep you posted.

-- 
Bojan
