Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2IECLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 22:11:50 -0400
Received: from ozlabs.org ([203.10.76.45]:49329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2IECLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 22:11:48 -0400
Message-ID: <1346811109.28652.1.camel@concordia>
Subject: Re: [PATCH] perf: allow user to indicate path to objdump in command
 line
From: Michael Ellerman <michael@ellerman.id.au>
To: David Ahern <dsahern@gmail.com>
Cc: Maciek Borzecki <maciek.borzecki@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Date: Wed, 05 Sep 2012 12:11:49 +1000
In-Reply-To: <504626CB.60601@gmail.com>
References: <1346754750.16299.3.camel@localhost.localdomain>
	 <504626CB.60601@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 10:05 -0600, David Ahern wrote:
> On 9/4/12 4:32 AM, Maciek Borzecki wrote:
> > When analyzing perf data from hosts of other architecture than one of the local
> > host it's useful to call objdump that is part of a toolchain for that
> > architecture. Instead of calling regular objdump, call one that user specified
> > in command line.
> 
> Why not set the PATH to make the toolchain's version the one used by perf?

At least one reason is that cross toolchains are usually built such that
the resulting binaries are called <target>-objdump, <target>-gcc etc.

cheers

