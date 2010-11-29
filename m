Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0K2Se5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:34:57 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:49379 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0K2Se4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:34:56 -0500
X-Spam-Processed: digidescorp.com, Mon, 29 Nov 2010 12:34:54 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 12.54.16.226
X-Return-Path: prvs=194921a097=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
From: "Steven J. Magnani" <steve@digidescorp.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?=E4=B9=94=E5=B4=87?= <qiaochong@loongson.cn>,
        hellogcc@freelists.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        gdb@sourceware.org, Valdis.Kletnieks@vt.edu
In-Reply-To: <13700.1291054229@localhost>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	 <20101129081619.GD5218@cr0.nay.redhat.com>
	 <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
	 <4CF36741.9000808@loongson.cn>
	 <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
	 <4CF3762B.9010102@loongson.cn>  <13700.1291054229@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 12:34:49 -0600
Message-ID: <1291055689.5489.1.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 13:10 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 29 Nov 2010 17:45:15 +0800, ä¹”å´‡ said:
> 
> > change mycc to this will work,:)
> > 
> > #!/bin/sh
> > gcc "$@" -O0 ||
> >  gcc "$@" -O1 ||
> >  gcc "$@"
> 
> That may result in issues - the problem is that there are places in the kernel
> where 'gcc -O0' will *compile* cleanly, but not actually *run* correctly.
> 

There may be arch-specific places that cannot be made to run -O0. 
See this thread from a few years ago:

http://www.spinics.net/lists/arm-kernel/msg24836.html

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


