Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2ESJTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 05:19:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28858 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab2ESJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 05:19:07 -0400
Date: Sat, 19 May 2012 12:22:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: linux-3.4-rc7: rcu_sched self-detected stall on CPU
Message-ID: <20120519092230.GQ16999@mwanda>
References: <4FB6B2C5.4090301@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB6B2C5.4090301@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is the same bug that I saw earlier.  That one was
fixed for me, although I couldn't say in which patch.

regards,
dan carpenter
