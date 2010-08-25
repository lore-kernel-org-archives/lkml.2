Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0HYQJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:09:25 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:55146 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab0HYQJX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 12:09:23 -0400
X-Greylist: delayed 3199 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 12:09:22 EDT
Date: Wed, 25 Aug 2010 17:09:15 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Unable to compile 2.6.36-rc2 on x86_64
Message-ID: <20100825160915.GA7768@deepthought>
References: <20100825151554.GA6763@deepthought> <20100825085251.5c47eebe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100825085251.5c47eebe.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=MUzUZGmkMigA:10 a=8nJEP1OIZ-IA:10 a=RdYSiLBOBmpQZ1Lj-gMA:9 a=C5wqZxgpcKRe5RleOwUTSySabn4A:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 08:52:51AM -0700, Randy Dunlap wrote:
> On Wed, 25 Aug 2010 16:15:54 +0100 Ken Moffat wrote:
> 
> > Hi,
> > 
> >  on x86_64 using a config that worked in 2.6.35.3 plus accepting the
> > default settings for new options, it fails with
> > 
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `toshiba_acpi_exit':
> > toshiba_acpi.c:(.text+0x1c5e07): undefined reference to
> > `led_classdev_unregister'
> 
> Needs recently-merged commit c76a3e1d6c52c5cc1371f1abc7381c5715ebdf7f.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
 Thanks.  I'm in the middle of cloning linus' tree at the moment
(from nothing - I'd long since thrown away my local copy to save
space), this will save me bisecting.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
