Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1IPQcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:32:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53541 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777Ab1IPQcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:32:17 -0400
Subject: Re: [PATCH 3/4] drivers/scsi/mpt2sas/mpt2sas_transport.c: take size
 of pointed value, not pointer
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        kernel-janitors@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Sep 2011 09:32:16 -0700
In-Reply-To: <1316156255-19509-3-git-send-email-julia@diku.dk>
References: <1316156255-19509-3-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316190736.19950.2.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 08:57 +0200, Julia Lawall wrote:
> Sizeof a pointer-typed expression returns the size of the pointer, not that
> of the pointed data.

Hi Julia.

I submitted the same thing in May.
I hope it takes this time.

https://lkml.org/lkml/2011/5/9/31


