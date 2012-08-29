Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab2IAMmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 08:42:45 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34119 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2IAMmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 08:42:44 -0400
From: Rusty Russell <rusty@au1.ibm.com>
To: Silas Boyd-Wickizer <sbw@mit.edu>, linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4 V2] Use get_online_cpus to avoid races involving CPU hotplug
In-Reply-To: <20120803193223.GA4227@mit.edu>
References: <20120803193223.GA4227@mit.edu>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 30 Aug 2012 06:02:11 +0930
Message-ID: <87k3whsalw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12090112-0260-0000-0000-000001C777B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silas Boyd-Wickizer <sbw@mit.edu> writes:

> Hello,
>
> This is the second version of the patches to fix races described in:
>
>   https://groups.google.com/forum/?fromgroups#!topic/linux.kernel/iSUDr94Qehc
>
> The changes in this version are:
>
>   * fix commit log typo;
>   * prevent a race in via_cputemp_exit;
>   * and a new patch that prevents races during init/exit in
>     drivers/hwmon/coretemp.c.

Hi Silas,

        Good work! How did you find these?

Cheers,
Rusty.

