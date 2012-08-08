Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab2HHPgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:36:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58497 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2HHPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:36:43 -0400
Message-ID: <50228781.7040502@gmail.com>
Date: Wed, 08 Aug 2012 23:36:33 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
CC: Rob Landley <rob@landley.net>, Milton Miller <miltonm@bga.com>,
        Borislav Petkov <bp@alien8.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening
 port
References: <gilii4nnxb.fsf@mx10.gouders.net> <kernel-nc-hints@mdm.bga.com> <501937F7.2070600@landley.net> <gi3946lin5.fsf@mx10.gouders.net> <gisjc5hvun.fsf@mx10.gouders.net> <CAM_iQpWoKGJTUjohn9_guktpBNbOazKY1_eUQozz_O6ZkRmyPg@mail.gmail.com> <giobmsiixa.fsf@mx10.gouders.net>
In-Reply-To: <giobmsiixa.fsf@mx10.gouders.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 02:33 PM, Dirk Gouders wrote:
>
>  From b3aec70d785d338b1b643fece6606cd32addaf0c Mon Sep 17 00:00:00 2001
> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Date: Thu, 2 Aug 2012 22:20:16 +0200
> Subject: [PATCH] netconsole.txt: revision of examples for the receiver of kernel messages
>
> There are at least 4 implementations of netcat with the BSD-based
> being the only one that has to be used without the -p switch to
> specify the listening port.
>
> Jan Engelhardt suggested to add an example for socat(1).
>
> Signed-off-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>

It looks like no one takes this patch, so I will take it together with 
my other netpoll/netconsole patches and send them to netdev.

Thanks!

