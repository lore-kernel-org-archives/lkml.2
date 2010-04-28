Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0D1CIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:08:23 -0400
Received: from ozlabs.org ([203.10.76.45]:33397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0D1CIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:08:20 -0400
Date: Wed, 28 Apr 2010 12:08:19 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, dank@kegel.com
Subject: Re: [PATCH 00/11] jump label v7
Message-ID: <20100428020819.GN12389@ozlabs.org>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	linux-kernel@vger.kernel.org, dank@kegel.com
References: <cover.1271427118.git.jbaron@redhat.com>
 <20100422.161700.191166551.davem@davemloft.net>
 <20100427.175858.134109609.davem@davemloft.net>
 <20100428013951.GM12389@ozlabs.org>
 <20100428014941.GA8389@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100428014941.GA8389@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:49:41PM -0400, Mathieu Desnoyers wrote:

> The crosstool package from Dan Kegel did a good job for this. Not sure
> it's currently maintained though. It was a very useful project, it's a
> shame if it does not live on. It would be good to have up-to-date and
> tested compilers for various architectures available on kernel.org,
> ideally with access to a package that helps building compilers for
> various architectures.

Trimmed the CC' as this is a bit of a tangent.

Crosstool did a good job but seems to be less current than we'd like for the
kernel[1].  When using crosstool in the past I found a lot of the complexity
was in *libc to the toolcahins I've built don';t have a libc so they're only
helpful for kernel (or similar) builds.

In terms of "testing", I build a kernel for each toolchain but I don't boot
them and in the past I think blackfin said that what I had wouldn't actually be
runable.  Last time I looked the wasn't a non-intel cross-toolchain for blackfin.

I shoudl also mention that a subset of these compilers are used to build test
linux-next daily.

Yours Tony

[1] http://www.kegel.com/crosstool/crosstool-0.43/buildlogs/
