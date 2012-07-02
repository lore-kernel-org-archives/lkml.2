Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2GBLSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:18:23 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57652 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab2GBLSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:18:21 -0400
Message-ID: <1341227897.2987.15.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] SCSI: Add SG_GET_SG_MAX_SEGMENT_SIZE ioctl to sg device
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        senwang@linux.vnet.ibm.com
Date: Mon, 02 Jul 2012 12:18:17 +0100
In-Reply-To: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
References: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 17:20 +0800, Cong Meng wrote:
> Add a new ioctl cmd to get the max segment size. It's useful in
> virtualization environment for guest to know the queue limits, so
> that the guest kicks off legal scsi command to a sg device.

What's wrong with simply looking in the /sys for this? Plus, if you can
come up with a justifiable reason, this needs to be in block as well so
we can send it to all SCSI devices regardless of what ULD people use.

James


