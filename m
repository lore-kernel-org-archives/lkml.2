Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab1AWFmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 00:42:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59056 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750802Ab1AWFmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 00:42:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/li6Ry99Tlv8u5aBfizMLfiMYEkuKGqW5byWPhpw
	SOzH5pe1s2grg8
Subject: Re: 'autogroup' sched code KILLING responsiveness
From: Mike Galbraith <efault@gmx.de>
To: Michael Witten <mfwitten@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinU7kFRSkNZ2JcyGYPWRF9LP48FqWZknVafm56a@mail.gmail.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
	 <1295648870.23779.15.camel@marge.simson.net>
	 <4d3b4ac1.26092a0a.6f30.ffffcf6b@mx.google.com>
	 <AANLkTinU7kFRSkNZ2JcyGYPWRF9LP48FqWZknVafm56a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 06:42:14 +0100
Message-ID: <1295761334.7883.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-22 at 21:32 -0600, Michael Witten wrote:
> On Sat, Jan 22, 2011 at 15:23, Michael Witten <mfwitten@gmail.com> wrote:
> > Of course, I have none of these problems when I disable:
> >
> >  CONFIG_AUTOGROUP_SCHED
> 
> Of course, if CONFIG_AUTOGROUP_SCHED is enabled, then the problem also
> goes away if the kernel is booted using the `noautogroup' parameter.

I built a UP kernel for my old P4 box, and fair group scheduling doesn't
appear to be working at all, whereas SMP does.  It was usable, but
pretty horrible.

I have other (hot) things to do atm, but will investigate this.  Thanks.

	-Mike

