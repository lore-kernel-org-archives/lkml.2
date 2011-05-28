Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab1E1EgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 00:36:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55784 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1E1EgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 00:36:08 -0400
Date: Fri, 27 May 2011 21:35:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for 2.6.39 merge window
Message-Id: <20110527213553.60851cb3.randy.dunlap@oracle.com>
In-Reply-To: <1306538045.12244.16.camel@mulgrave.site>
References: <1306538045.12244.16.camel@mulgrave.site>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4DE07BB4.00FF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 18:14:04 -0500 James Bottomley wrote:

> This contains further driver updates (lpfc, mpt2sas, megaraid_sas, bnx2i
> and fcoe) plus an assortment of bug fixes
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git


OK, guess I can just send kernel-doc fixes for SCSI directly to Linus then.
(Saturday)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
