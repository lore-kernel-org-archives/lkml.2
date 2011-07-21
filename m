Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1GUVQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1GUVQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:16:22 -0400
Date: Thu, 21 Jul 2011 18:16:10 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Add support to install perf python
	extension
Message-ID: <20110721211610.GE24324@ghostprotocols.net>
References: <1311266726-20655-1-git-send-email-jolsa@redhat.com> <20110721171148.GB24324@ghostprotocols.net> <20110721184715.GA2425@jolsa.Belkin> <20110721190407.GC24324@ghostprotocols.net> <20110721194150.GB2425@jolsa.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721194150.GB2425@jolsa.Belkin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 21, 2011 at 09:41:50PM +0200, Jiri Olsa escreveu:
> On Thu, Jul 21, 2011 at 04:04:07PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jul 21, 2011 at 08:47:15PM +0200, Jiri Olsa escreveu:
> > > nope, I added install-python_ext since it installs to the
> > > python system lib area, and it could break standard install

> > But where is that it picks the binaries built? The problem I was
> > experiencing was that it wasn't obeying O=, just using the source dir
 
> I haven't checked the 'O=' that much.. will do :)
 
> > as the build dir, effectively building it again, in a different place.
 
> I dont have that much experince with python, but here's what I found:
> (might be missing something..)

<SNIP>
 
> Also there might be a way to overload distutils class and put our
> specific options to this new class..
 
> As I checked some of python extension packages, some of them
> do not use distutils at all.. can't imagine why ;)

Ok, we're on the same page with that ';)' ;)

I'd love to use what is 'pythonic', i.e. whatever the python people
think we should use and don't bother with all the module
build/install details, but since we want to have O= working...

- Arnaldo
