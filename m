Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2HRW1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:27:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39080 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2HRW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:27:45 -0400
MIME-Version: 1.0
In-Reply-To: <c925f795-28d8-4e6d-8131-9a14d6e83659@email.android.com>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	<CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	<c925f795-28d8-4e6d-8131-9a14d6e83659@email.android.com>
Date: Sun, 19 Aug 2012 00:27:44 +0200
Message-ID: <CAFLxGvz_3koT5sm+mU5ntpAjzE=ARLbebP3Yjr8uB2_Ac7OMDA@mail.gmail.com>
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Dan Luedtke <mail@danrl.de>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, chaosman@ontika.net, muthur@gmail.com,
        kerolasa@iki.fi, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 12:22 AM, Dan Luedtke <mail@danrl.de> wrote:
> That's the feature, actually. Think of the Arduino platform or other
> embedded devices (TV, Car Entertainment) that just want to read/play files.
> You're right, no big features, but that's by design.

So your fs is designed to run on top of NAND/NOR flash memory?

-- 
Thanks,
//richard
