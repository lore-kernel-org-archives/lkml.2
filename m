Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1BIU3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:29:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab1BIU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:29:01 -0500
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
From: James Bottomley <James.Bottomley@suse.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1297282835.18212.57.camel@haakon2.linux-iscsi.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110209092851.bba6c40c.randy.dunlap@oracle.com>
	 <AANLkTikvGppAi1JCGY1vjAugzpk3g5rDriBjc8k6M9Qg@mail.gmail.com>
	 <1297281744.18212.44.camel@haakon2.linux-iscsi.org>
	 <1297282433.3016.43.camel@mulgrave.site>
	 <1297282835.18212.57.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 14:28:55 -0600
Message-ID: <1297283335.3016.48.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 12:20 -0800, Nicholas A. Bellinger wrote:
> On Wed, 2011-02-09 at 14:13 -0600, James Bottomley wrote:
> > Firstly, could we get the serious bug fixes identified and separated
> > from the general enhancement updates, so they can go in a fixes tree
> > without depending on enhancements?  The former category would include
> > the /proc interface removal, since we don't want the legacy interface to
> > be in a released kernel.
> > 
> 
> Everything in those two series should be considered bug fixes and
> immediate for-38 mainline material.

Things like this:

target: remove EXTRA_CFLAGS
target: Remove unnecessary container_of() pointer check
target: Remove unnecessary se_clear_dev_ports legacy code
target: Remove spurious double cast from structure macro accessors
target: Convert TMR REQ/RSP definitions to target namespace
target: Minor sparse warning fixes and annotations
target: Remove unneeded test of se_cmd

Are not serious bug fixes.  I could go either way on some of the error path changes.

James


