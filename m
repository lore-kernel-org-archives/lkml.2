Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1FHTxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:53:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45763 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1FHTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:53:03 -0400
Date: Wed, 8 Jun 2011 12:52:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: linux-next: Tree for June 8 (docbook/media)
Message-Id: <20110608125243.e63a07fc.randy.dunlap@oracle.com>
In-Reply-To: <20110608161046.4ad95776.sfr@canb.auug.org.au>
References: <20110608161046.4ad95776.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DEFD317.0043:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 16:10:46 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110607:


Hi Mauro,

The DocBook/media/Makefile seems to be causing too much noise:

ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.gif: No such file or directory
ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.png: No such file or directory


Maybe the cleanmediadocs target could be made silent?

also, where is the mediaindexdocs target defined?


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
