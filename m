Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1ALSB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:01:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57291 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1ALSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:01:57 -0500
Date: Wed, 12 Jan 2011 10:01:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 12 (dm-crypt)
Message-Id: <20110112100121.ba610465.randy.dunlap@oracle.com>
In-Reply-To: <20110112141822.c29314c4.sfr@canb.auug.org.au>
References: <20110112141822.c29314c4.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 14:18:22 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Reminder: do not add any v2.6.39 material to your linux-next included
> trees until after v2.6.38-rc1 is released.
> 
> Changes since 20110111:


When CONFIG_LBDAF is not enabled (build on i386):
(sector_t is 32 bits)

drivers/md/dm-crypt.c:568: warning:right shift count >= width of type

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
