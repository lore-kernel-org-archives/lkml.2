Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1CJXPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:15:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab1CJXPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:15:15 -0500
Date: Thu, 10 Mar 2011 15:15:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] sysfs: add more info to the oops dump
Message-Id: <20110310151503.cd1425c4.akpm@linux-foundation.org>
In-Reply-To: <20110310230304.GA5254@suse.de>
References: <20110310212746.GA3361@suse.de>
	<1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<1299796027-3343-2-git-send-email-ext-phil.2.carmody@nokia.com>
	<20110310143806.7542e929.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6>
	<20110310230304.GA5254@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 15:03:04 -0800
Greg KH <gregkh@suse.de> wrote:

> > Amen to that.
> > 
> > It's more of an distraction than anything which is relevant to 99.999%
> > of the problems we have to deal with.
> 
> Ok, I think I'll delete it as I'm tired of having to filter it out of my
> "any problem with sysfs" lkml filter that I use :)

Ok, I'll assign future incomprehensible sysfs oops traces to you guys ;)
