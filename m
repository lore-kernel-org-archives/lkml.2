Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab2GIKsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:48:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38810 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2GIKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:48:17 -0400
Date: Mon, 9 Jul 2012 03:48:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Aaro Koskinen <aaro.koskinen@iki.fi>
cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] Documentation: talk about "Cc: stable@vger.kernel.org"
In-Reply-To: <20120706215944.GA6154@blackmetal.musicnaut.iki.fi>
Message-ID: <alpine.DEB.2.00.1207090345540.8224@chino.kir.corp.google.com>
References: <1341610730-6277-1-git-send-email-tytso@mit.edu> <20120706215944.GA6154@blackmetal.musicnaut.iki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2012, Aaro Koskinen wrote:

> > I couldn't remember whether the canonical marking is stable@kernel.org
> > or stable@vger.kernel.org, so I went looking, and discovered that it
> > wasn't mentioned in the kernel sources.  You can find mention of it in
> > Greg K-H's blog, but not everyone would necessarily find this blog
> > entry.
> 
> It's documented in Documentation/stable_kernel_rules.txt.
> 

I'm wondering if it would be helpful to the stable maintainers if we 
explicitly asked that patches including "Cc: stable@vger.kernel.org" also 
include the version number of the earliest version that the change should 
be backported to?

Andrew and others do this quite often with

	Cc: stable@vger.kernel.org [3.2+]

so perhaps such a convention should be added to the documentation?
