Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab0J1R2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:28:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29600 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054Ab0J1R2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:28:00 -0400
Date: Thu, 28 Oct 2010 10:26:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        gregkh <greg@kroah.com>
Subject: Re: How do I add yaffs file system to mainline?
Message-Id: <20101028102641.d936aec8.randy.dunlap@oracle.com>
In-Reply-To: <201010290455.02390.manningc2@actrix.gen.nz>
References: <201010290455.02390.manningc2@actrix.gen.nz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 04:55:02 +1300 Charles Manning wrote:

> YAFFS has been used for many years as a third-party patch-in.
> 
> I have recently been through the exercise of changing all the symbols to be 
> more kernel friendly with the intention of mainlining into the linux tree.
> 
> The code is in git at http://github.com/cdhmanning/linux-yaffs-integration/

It's difficult to review & comment on a git tree.
We prefer patches via email for review.

> Thanks to CELF and Google for sponsoring the effort so far.
> 
> What still needs to be done to mainline this?
> Who do I need to approach?

Either ask Stephen Rothwell to add the git tree to the linux-next daily tree
or ask Greg KH to add it to the drivers/staging/ area.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
