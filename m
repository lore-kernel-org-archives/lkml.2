Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2GJLy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:54:59 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40906 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab2GJLy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:54:58 -0400
Date: Tue, 10 Jul 2012 14:54:55 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: linux-scsi@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com,
        support@lsi.com
Subject: Re: mptscsi: BUG: unable to handle kernel NULL pointer, in
 scsi_send_eh_cmnd
In-Reply-To: <1341911745.3021.40.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.SOC.1.00.1207101452270.9883@math.ut.ee>
References: <alpine.SOC.1.00.1207101143030.9883@math.ut.ee> <1341911745.3021.40.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am using Linux 3.4.0 with a 53c1030 and a tape library that sometimes 
> > barfs for yet unknown reasons. When it happens, I get a BUG with 
> > backtrace and this scsi channel is dead until I reboot. Seems to be 
> > something with either generic scsi error handling or with mpt scsi.
> 
> I think it might actually be fixed by this:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=222a806af830fda34ad1f6bc991cd226916de060

Tested on top on 3.4.0, works - mptscsih is reset successfully, domain 
validation for all scsi devices succeeds, no BUG. Scsi communication 
works.

-- 
Meelis Roos (mroos@linux.ee)
