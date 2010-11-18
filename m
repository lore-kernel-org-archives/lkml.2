Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab0KRUKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:10:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58575 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755568Ab0KRUKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:10:33 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18wAFtswtowmG//OqHBVEVIJ2doACXgmjN1Hyt0iw
	t0xrtaZ2hjkigR
Subject: Re: Galbraith patch
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Thomas Backlund <tmb@mandriva.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201011181435.17062.gene.heskett@gmail.com>
References: <1290018947.4887.14.camel@note-311a>
	 <1290096365.30211.5.camel@maggy.simson.net> <4CE5731B.20807@mandriva.org>
	 <201011181435.17062.gene.heskett@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 13:10:15 -0700
Message-ID: <1290111015.10702.16.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 14:35 -0500, Gene Heskett wrote:

> >and more importantly it misses theese:
> >>>   kernel/sched_autogroup.c            |  170
> >>>   ++++++++++++++++++++++++++++++++++++ kernel/sched_autogroup.h      
> >>>        |   23 ++++
> >
> >Wich means it wont build...
> 
> As I just found also.

Creating patch while heading for the door doesn't always work:)

