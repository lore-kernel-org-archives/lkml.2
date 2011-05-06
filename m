Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1EFPkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:40:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24912 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1EFPkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:40:43 -0400
Date: Fri, 6 May 2011 08:40:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (wireless)
Message-Id: <20110506084031.a1f2e483.randy.dunlap@oracle.com>
In-Reply-To: <20110506154921.47700781.sfr@canb.auug.org.au>
References: <20110506154921.47700781.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DC41674.0059:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 15:49:21 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110505:


when PM is not enabled:

net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no member named 'suspend'
net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no member named 'resume'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
