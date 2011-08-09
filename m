Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1HIQat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:30:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46439 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595Ab1HIQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:30:46 -0400
X-Sasl-enc: 1DWLtRCWq25AClmR3u4vbzw5DRS/0pKsgOBi4YbYkkWf 1312907445
Date: Tue, 9 Aug 2011 09:13:22 -0700
From: Greg KH <greg@kroah.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Subject: Re: [stable] [PATCH] hpsa: fix problem that OBDR devices are not
 detected
Message-ID: <20110809161322.GB8756@kroah.com>
References: <20110809131730.10599.22108.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809131730.10599.22108.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:17:30AM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> The test to detect OBDR ("One Button Disaster Recovery")
> cd-rom devices was comparing against uninitialized data.
> 
> Fixed by moving the test for the device to where the
> inquiry data is collected, and uninitialized variable
> altogether as it wasn't really being used.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |   47 +++++++++++++++++++++++++++--------------------
>  1 files changed, 27 insertions(+), 20 deletions(-)
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
