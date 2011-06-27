Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1F0XU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:20:28 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52463 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1F0XSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:18:20 -0400
Date: Mon, 27 Jun 2011 19:16:20 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Peter Foley <pefoley2@verizon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: Re: [PATCH] kbuild: silence generated makefile message
In-reply-to: <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
Message-id: <alpine.LNX.2.00.1106271915160.38876@linux>
References: <alpine.LNX.2.00.1106271619350.24034@linux>
 <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Arnaud Lacombe wrote:

> Hi,
> 
> On Mon, Jun 27, 2011 at 5:42 PM, Peter Foley <pefoley2@verizon.net> wrote:
> >
> > This patch silences the make -C /usr/src/git O=/usr/src/git/build/.
> > message shown when using the generated makefile in KBUILD_OUTDIR.
> >
> I would expect verbose build to show that message. not hides it
> unconditionally, no ?
> 
>  - Arnaud
> 

Good point, I'll fix that.

Thanks,

Peter
