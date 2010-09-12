Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0ILK5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 06:57:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:46121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0ILK5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 06:57:19 -0400
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
From: Peter Zijlstra <peterz@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Corentin Chary <corentincj@iksaif.net>, fweisbec <fweisbec@gmail.com>
In-Reply-To: <20100912102854.GA7359@sucs.org>
References: <20100912102854.GA7359@sucs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 12 Sep 2010 12:57:07 +0200
Message-ID: <1284289027.2251.95.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 11:28 +0100, Sitsofe Wheeler wrote:
> Hi,
> 
> On an EeePC 900 running 2.6.36rc3 I've been finding that the laptop
> immediately reboots or hangs forever if I run
> 
> perf -a -f -g xset dpms force off
> 
> . I've got lockdep checking and stack overflow checking on but these
> don't make any difference. Using only -a -f doesn't show the problem. I
> have also found that disabling eeepc-laptop in the kernel config also
> removes the problem.
> 
> Any suggestions?

Bisect it?

Does .35 work? If so, you could try it with the .35 version of
eeepc-laptop driver to see if its something specific to that driver, or
if its something we did to the stack unwinding code.

Most curious issue..
