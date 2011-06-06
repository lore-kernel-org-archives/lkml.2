Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1FFTzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:55:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40149 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1FFTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:55:51 -0400
Date: Mon, 6 Jun 2011 12:55:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-sctp@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for June 6 (sctp)
Message-Id: <20110606125532.793b3cfd.randy.dunlap@oracle.com>
In-Reply-To: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
References: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4DED30C2.0045:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 13:20:36 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110603:


when CONFIG_IPV6 is not enabled:

ERROR: "ipv6_chk_addr" [net/sctp/sctp.ko] undefined!



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
