Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2IETfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:35:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2IETfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:35:50 -0400
Date: Wed, 5 Sep 2012 15:35:39 -0400 (EDT)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@new-host-2
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
In-Reply-To: <yq1d32ph515.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.LFD.2.00.1209051534110.509@new-host-2>
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com> <yq1d32ph515.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012, Martin K. Petersen wrote:

> Date: Fri, 17 Aug 2012 12:11:50 -0400
> From: Martin K. Petersen <martin.petersen@oracle.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, tytso@mit.edu,
>     pbonzini@redhat.com, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
> 
> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> Lukas> Currently it is possible to unmap one more block than user
> Lukas> requested to due to the off-by-one error in unmap_region(). This
> Lukas> is probably due to the fact that the end variable despite its
> Lukas> name actually points to the last block to unmap + 1. However in
> Lukas> the condition it is handled as the last block of the region to
> Lukas> unmap.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

I am still not seeing it in anywhere, is this going in any time soon
?

Thanks!
-Lukas
