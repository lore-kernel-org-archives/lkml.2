Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab0EDSgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:36:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35547 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab0EDSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:36:37 -0400
Date: Tue, 4 May 2010 11:36:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Marin Mitov <mitov@issp.bas.bg>
Subject: Re: linux-next: Tree for May 4 (staging/dt3155v4l)
Message-Id: <20100504113604.fe00959d.randy.dunlap@oracle.com>
In-Reply-To: <20100504162305.4a07a18a.sfr@canb.auug.org.au>
References: <20100504162305.4a07a18a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BE0691B.0085:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010 16:23:05 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100503:


drivers/staging/dt3155v4l/dt3155v4l.c:73: error: implicit declaration of function 'udelay'
drivers/staging/dt3155v4l/dt3155v4l.c:616: warning: assignment from incompatible pointer type
drivers/staging/dt3155v4l/dt3155v4l.c:1270: error: implicit declaration of function 'msleep'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
