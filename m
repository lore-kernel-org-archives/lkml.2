Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1KHQjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:39:35 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34845 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab1KHQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:39:34 -0500
Subject: Re: [PATCH 0000/0011] Staging: hv: storvsc cleanup/new features
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, hch@infradead.org
In-Reply-To: <1320771677-29095-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 10:39:30 -0600
Message-ID: <1320770370.2883.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 09:01 -0800, K. Y. Srinivasan wrote:
> Cleanup storvsc based on review comments from James and
> implement a couple of new features:
> 
> 	1) The bulk of this patch-set addresses the review comments by James.
> 	   James, the last time I had posted the patch to move the storage
> 	   driver out of staging, you wanted to wait until Greg's tree had
> 	   percolated up. Now, Greg's staging/hv has been merged up. Do you 
> 	   now want me to re-post the patch to move the storage driver 
> 	   out of staging? Let me know.
> 
> 	2) I have also implemented the feature to support hot add/remove
> 	   of devices configured under the scsi controller on the host.

If you want scsi review on this, it should go to the scsi list:

linux-scsi@vger.kernel.org

James


