Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2APMTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:19:03 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64543 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400Ab2APMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:19:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120111113507.GB14423@infradead.org>
References: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
	<20120111113507.GB14423@infradead.org>
Date: Mon, 16 Jan 2012 17:49:00 +0530
Message-ID: <CADDb1s110TS6STfV9f6t+W4h5Bo21PXLu=nhHgDojkGhT03Kag@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, Ben Myers <bpm@sgi.com>,
        xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks Christoph,

Resent the patch after the subject change.

Regards,
Amit Sahrawat

On Wed, Jan 11, 2012 at 5:05 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jan 06, 2012 at 04:42:18PM +0530, Amit Sahrawat wrote:
>> Removing the macro, as this is no more needed in the code.
>> Tried to find the reference when it was last used - but the usage
>> for this seemed to have been dropped long time ago.
>>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>
> This looks good, but the subject should be something like:
>
> "xfs: kill the unused XFS_BB_FSB_OFFSET macro"
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
