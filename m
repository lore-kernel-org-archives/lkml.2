Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1EZTHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:07:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39610 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab1EZTHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:07:18 -0400
Date: Thu, 26 May 2011 12:07:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>
Subject: Re: linux-next: Tree for May 26 (drivers/net/caif)
Message-Id: <20110526120702.fac24de0.randy.dunlap@oracle.com>
In-Reply-To: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DDEA4E0.005B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 16:39:41 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> [The kernel.org mirroring is being slow today]


(not new)

drivers/net/caif/caif_serial.c:194: warning: 'return' with no value, in function returning non-void
drivers/net/caif/caif_serial.c:202: warning: 'return' with no value, in function returning non-void


I'm curious:  how do warnings like this get overlooked?
too much noise in the build messages?  or it wasn't overlooked, just ignored?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
