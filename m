Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1HDOko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:40:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40915 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462Ab1HDOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:40:32 -0400
X-Sasl-enc: 7lVS/kdsFyp8mZH5osvy8F1wJKNqwnysyKL5RedKn2Rl 1312468831
Date: Thu, 4 Aug 2011 07:39:30 -0700
From: Greg KH <greg@kroah.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] hpsa: retry commands completing with status of
 UNSOLICITED_ABORT
Message-ID: <20110804143930.GD18468@kroah.com>
References: <20110726160852.7394.78474.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726160852.7394.78474.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:08:52AM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> In a shared SAS setup, target devices may be reset by one of
> several hosts, and outstanding commands on that device will be
> completed to corresponding hosts with status of UNSOLICITED_ABORT.
> Such commands should be retried instead of being treated as i/o
> errors.  Also fixed a nearby spelling error.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
