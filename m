Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1DUOl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:41:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61440 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1DUOl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:41:57 -0400
Date: Thu, 21 Apr 2011 07:41:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: linux-next: Tree for April 21 (md/raid456)
Message-Id: <20110421074113.5a0410fc.randy.dunlap@oracle.com>
In-Reply-To: <20110421132045.5af1b953.sfr@canb.auug.org.au>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DB04222.001E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:

> Changes since 20110420:


on i386:

ERROR: "__udivdi3" [drivers/md/raid456.ko] undefined!

in raid45_takeover_raid0()

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
