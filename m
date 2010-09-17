Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0IQQrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:47:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38819 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0IQQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:47:18 -0400
Date: Fri, 17 Sep 2010 09:46:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 17
Message-Id: <20100917094614.dc9a7c96.randy.dunlap@oracle.com>
In-Reply-To: <20100917135832.ab83b7cf.sfr@canb.auug.org.au>
References: <20100917135832.ab83b7cf.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010 13:58:32 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100916:


btw, what is this file?

-rw-r--r-- 	126 	t_first_entry(&list, struct net_device, todo_list); 	blob | history | raw

as seen from:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=tree
(or in my local ls -l)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
