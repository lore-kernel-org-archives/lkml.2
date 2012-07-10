Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2GJOEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:04:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:6500 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2GJOEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166260734"
Date: Tue, 10 Jul 2012 17:04:02 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/8] /proc/net/ entries for bluetooth protocols
Message-ID: <20120710140400.GA15795@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120615080007.GD7205@aemeltch-MOBL1>
 <20120617.092637.2171077367789127221.yamato@redhat.com>
 <20120618082826.GA2898@aemeltch-MOBL1>
 <20120629.020253.963694178693689545.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629.020253.963694178693689545.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Fri, Jun 29, 2012 at 02:02:53AM +0900, Masatake YAMATO wrote:
> Hi, Andrei
> 
> Could you review my v2 patch set I submitted?

It does not apply, trailing white spaces and it also seems that they are
based on different repository. Please rebase against bluetooth-next. 

Applying: /proc/net/ entries for bluetooth protocols
bluetooth-next-orig.git/.git/rebase-apply/patch:33:
trailing whitespace.
extern int  bt_procfs_init(struct module* module, struct net *net, const
char *name, 
bluetooth-next-orig.git/.git/rebase-apply/patch:140:
trailing whitespace.
	 
bluetooth-next-orig.git/.git/rebase-apply/patch:157:
trailing whitespace.
	
bluetooth-next-orig.git/.git/rebase-apply/patch:163:
trailing whitespace.
	
error: patch failed: include/net/bluetooth/bluetooth.h:30
error: include/net/bluetooth/bluetooth.h: patch does not apply
Patch failed at 0001 /proc/net/ entries for bluetooth protocols
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

> 
>       https://lkml.org/lkml/2012/6/18/170
> 
> Masatake YAMATO

Best regards 
Andrei Emeltchenko 
