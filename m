Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2HCFaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:30:22 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39382 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HCFaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <gisjc5hvun.fsf@mx10.gouders.net>
References: <gilii4nnxb.fsf@mx10.gouders.net>
	<kernel-nc-hints@mdm.bga.com>
	<501937F7.2070600@landley.net>
	<gi3946lin5.fsf@mx10.gouders.net>
	<gisjc5hvun.fsf@mx10.gouders.net>
Date: Fri, 3 Aug 2012 13:30:19 +0800
Message-ID: <CAM_iQpWoKGJTUjohn9_guktpBNbOazKY1_eUQozz_O6ZkRmyPg@mail.gmail.com>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Rob Landley <rob@landley.net>, Milton Miller <miltonm@bga.com>,
        Borislav Petkov <bp@alien8.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 4:39 AM, Dirk Gouders
<gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>
> From d756d2750e4cf07d3c0942dc3c491d57631d4338 Mon Sep 17 00:00:00 2001
> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Date: Thu, 2 Aug 2012 22:20:16 +0200
> Subject: [PATCH] netconsole.txt: revision of examples for the receiver of kernel messages
>
> There are at least 4 implementations of netcat with the BSD-based
> being the only one that has to be used without the -p switch to
> specify the listening port.
>
> Jan Engelhardt suggested to add an example for socat(1).


Looks good, but you missed your SOB.
