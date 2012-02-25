Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2BYO41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 09:56:27 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36523 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756699Ab2BYO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 09:56:25 -0500
Message-ID: <1330181783.2437.3.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.3-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 25 Feb 2012 08:56:23 -0600
In-Reply-To: <4F482E0C.2000604@panasas.com>
References: <1330126189.2831.44.camel@dabdike.int.hansenpartnership.com>
	 <4F482E0C.2000604@panasas.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 16:40 -0800, Boaz Harrosh wrote:
> On 02/24/2012 03:29 PM, James Bottomley wrote:
> > This is a set of assorted bug fixes for power management, mpt2sas, ipr,
> > the rdac device handler and quite a big chunk for qla2xxx (plus a use
> > after free of scsi_host in scsi_scan.c).
> > 
> 
> James? what's up?
> 
> I sent you, what is for me a very important fix, also targeted for stable
> which is a one liner. I don't see it below. Do you plan on another scsi-fixes
> batch?

Sorry about that ... apparently I forgot to tag the actual patch itself
in the SCSI tree.

You should have received the normal email now and it's queued for the
next round of rc fixes.

James


