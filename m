Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1EPQBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:01:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57794 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab1EPQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:01:20 -0400
Date: Mon, 16 May 2011 18:01:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110516160114.GA25898@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org> <BANLkTikP==HkDSG1oKcfSKAhrWOXRqGF5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikP==HkDSG1oKcfSKAhrWOXRqGF5w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...and libc will start making many such calls in a row in order to retrieve
> a dozen of such values.

It doesn't because the user interface is sysconf(). So the user program
just asks for it piece by piece.

> It's rather inefficient to return just one word.
> Try to return more data per call.

I considered that, but is there a concrete use case?
I didn't want to code it up without concrete use case.

> Pass a pointer to the result struct and its length.
> Future-proof API, such as using generously wide data types,
> passing "version of struct" input parameter to facilitate incompatible
> future changes, etc.

Please provide a use case for all this complexity.

[... more complexity snipped ... ]

-Andi
