Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1I1HZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:25:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33297 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1I1HZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <1317194324.1998.12.camel@shrek.rexursive.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	<CAOJsxLGt717Mn50xZC5TD2s64A9vt27eAHRRFg+6nbworD4byQ@mail.gmail.com>
	<1317194324.1998.12.camel@shrek.rexursive.com>
Date: Wed, 28 Sep 2011 10:25:03 +0300
X-Google-Sender-Auth: j3C-C0_2TgtXYMHPaUQm9Ge-DYI
Message-ID: <CAOJsxLFtrP1jiczYpoxFvyvjUoB_0xtG=6ODkMu2De3MihPZxg@mail.gmail.com>
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:14 +0300, Pekka Enberg wrote:
>> So how do the numbers look like without your patch?
>
> Write is about 110 - 120 MB/s. Read is always below 100 MB/s, mostly
> around 50 - 70 MB/s.

So that's 2x-3x improvement? Impressive! Please remember to make that
important detail part of your changelog.

                        Pekka
