Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2CaOmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:42:55 -0400
Received: from seven.medozas.de ([188.40.89.202]:50511 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495Ab2CaOmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:42:52 -0400
Date: Sat, 31 Mar 2012 16:42:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
In-Reply-To: <4F718007.4000401@jp.fujitsu.com>
Message-ID: <alpine.LNX.2.01.1203311639530.8967@frira.zrqbmnf.qr>
References: <4F718007.4000401@jp.fujitsu.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2012-03-27 10:53, KAMEZAWA Hiroyuki wrote:

>Provides another format of /proc/stat for showing data in binary and
>compress sequence of Zeros to some extent.
>
>Any other idea of formats ?

Rather than adding more obscure formats and fields to /proc(/N)/stat, we 
should pursue descriptive lines like in /proc/N/status.
Or, if so desired, sysfs-style splitted attributes where the filename 
takes on the description.
