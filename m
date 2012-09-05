Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab2IETtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:49:23 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45522 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759143Ab2IETtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:49:21 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2012 15:49:21 EDT
Message-ID: <5047AAD9.90106@interlog.com>
Date: Wed, 05 Sep 2012 15:41:13 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Lukas Czerner <lczerner@redhat.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com> <yq1d32ph515.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1d32ph515.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-17 12:11 PM, Martin K. Petersen wrote:
>>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
>
> Lukas> Currently it is possible to unmap one more block than user
> Lukas> requested to due to the off-by-one error in unmap_region(). This
> Lukas> is probably due to the fact that the end variable despite its
> Lukas> name actually points to the last block to unmap + 1. However in
> Lukas> the condition it is handled as the last block of the region to
> Lukas> unmap.
>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
