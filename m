Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2CUIdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:33:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59574 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2CUIc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120321053735.GO6589@ZenIV.linux.org.uk>
References: <CAN628AE8gytYTE3eGDYrKR9Vx4JnND+OGzHcfneCb4q-QUM6cA@mail.gmail.com>
	<20120321053735.GO6589@ZenIV.linux.org.uk>
Date: Wed, 21 Mar 2012 16:32:59 +0800
Message-ID: <CACwZE5TaUBLwsz0qMNqih9qnE1awP3i048ds-Say+xMAJXnMDA@mail.gmail.com>
Subject: Re: [PATCH] VMUFAT filesystem [2/4]
From: Adrian McMenamin <adrianmcmenamin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Adrian McMenamin <lkmladrian@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2012 13:37, Al Viro <viro@zeniv.linux.org.uk> wrote:

...

OK, points essentially taken and will push through another patch in
due course ... just a couple of points, though:

* Did the defensive stuff because bad guys might inject evil code
rather than because I thought in normal run of execution there would
be an issue - guess I just have to forget that?

* On the semaphore - what should I use? Uninterruptible? Spinlock?
Aren't there big downsides to them also?
