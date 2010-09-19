Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0ISItz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 04:49:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2108 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0ISIty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 04:49:54 -0400
Subject: Re: [PATCH v2] scripts: add typdef removal tool
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        mcgrof@gmail.com, Julia Lawall <julia@diku.dk>,
        Nicolas Palix <npalix@diku.dk>,
        Yoann Padioleau <yoann.padioleau@gmail.com>
In-Reply-To: <AANLkTi==_Tvt6hosvfKDdd9uivsa5SVPiqSHNg5Ob3-v@mail.gmail.com>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
	 <AANLkTi==_Tvt6hosvfKDdd9uivsa5SVPiqSHNg5Ob3-v@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 01:49:52 -0700
Message-ID: <1284886192.1778.94.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 11:19 +0300, Pekka Enberg wrote:
> On Fri, Aug 14, 2009 at 8:39 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > If you are porting drivers and need to remove tydpefs you can use
> > this to help you port the driver faster. Until we don't have a fully
> > correct and complete way to do this through Coccinelle spatch we
> > might as well help developers porting drivers with something. spatch
> > also has a learning curve, people working on staging may not end
> > up using it for a while.
> How come this script never made it to the kernel tree?

General lack of interest?

Probably the same reason that similar patches didn't.
https://patchwork.kernel.org/patch/88026/


