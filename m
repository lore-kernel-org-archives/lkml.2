Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1DTS2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:28:05 -0400
Received: from kroah.org ([198.145.64.141]:36703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab1DTS2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:28:03 -0400
Date: Wed, 20 Apr 2011 11:17:00 -0700
From: Greg KH <greg@kroah.com>
To: li jianyun <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Add Marvell UMI driver
Message-ID: <20110420181700.GA8143@kroah.com>
References: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
 <20110420142626.GA22114@kroah.com>
 <BANLkTimL4ndgb7FRkr393AD=yOCVyJ1QuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimL4ndgb7FRkr393AD=yOCVyJ1QuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:58:30PM +0800, li jianyun wrote:
> Hi Grep KH
>       thanks for your remind,I am a beginner，and don't know how to
> send patch to kernel.
> I will update the Signed-off-by. Do I need update the subject to
> "[PATCH][RESEND] Add Marvell UMI driver" when I resend this patch?
>      thanks for your patient.

No, just do:
	[patch v2]
as git will strip out the first set of [] markings, but not the second
when applying the patch.

thanks,

greg k-h
