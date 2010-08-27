Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0H0Mjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0H0Mjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:39:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTi=QoMLTEDVfW0oKGVs-MhG+GpNxjC6axzLaHFKR@mail.gmail.com>
References: <AANLkTi=QoMLTEDVfW0oKGVs-MhG+GpNxjC6axzLaHFKR@mail.gmail.com> <20100826141110.11132.91931.stgit@warthog.procyon.org.uk> <20100826141115.11132.52122.stgit@warthog.procyon.org.uk> <AANLkTinxwf6kY6hCnUn=ATSYFutCAeSJQ1pgUj11UfD4@mail.gmail.com> <32426.1282852938@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [Uclinux-dist-devel] [PATCH 2/7] Blackfin: Don't redefine blackfin serial port symbols
Date: Fri, 27 Aug 2010 13:39:19 +0100
Message-ID: <6708.1282912759@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> this guy:
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=8e289204d2d190a8b430edf956a315ba383d85f6

Cool.  Replaced my patch with that.

Any chance I can get you to test my patches?  At least the ones applicable to
Blackfin...

David
