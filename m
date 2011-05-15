Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab1EOQO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:14:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47850 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760066Ab1EOQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:14:27 -0400
Date: Sun, 15 May 2011 09:14:27 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv3 -next] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110515161426.GF26637@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 05:29:29PM +0530, Ashish Jangam wrote:
> Hi Mark,
> MFD Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . moved read_events to irq file
> . logic modified for the chip method bus_sync_unlock
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> ---

The last time you posted this series I and several other people reminded
you that you should be taking care of all the stuff in SubmittingPatches,
especially the Signed-off-by.  Looking at the above there's been no
change in what you're submitting.

I've not read the actual patch.
