Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2IWN2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 09:28:48 -0400
Received: from ares07.inai.de ([5.9.24.206]:46503 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab2IWN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 09:28:47 -0400
Date: Sun, 23 Sep 2012 15:28:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-modules <linux-modules@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Reisner <d@falconindy.com>
Subject: Re: Drop support to compressed modules?
In-Reply-To: <CAMOw1v7ihLgrrtgak2s9hDDsUrSnD7wO8FJTrZvsrJzarH6ZRg@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1209231528350.15692@nerf07.vanv.qr>
References: <CAMOw1v7ihLgrrtgak2s9hDDsUrSnD7wO8FJTrZvsrJzarH6ZRg@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-09-21 23:41, Lucas De Marchi wrote:
>
>While fixing a bug in kmod related to using compressed modules (that
>already existed in module-init-tools) we stopped to think about these
>questions. Dave made a couple of benchmarks and performance wise it's
>better to use uncompressed modules than modules with gz or xz
>compression. However the benchmark was done in only 1 computer. I do
>expect people with slow storage to have different numbers though. Does
>anyone have these numbers?

What benchmark should be run?
