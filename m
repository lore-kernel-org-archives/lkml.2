Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2JAQe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:34:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37961 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2JAQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121001163338.GP4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
	<1348835046-3262-10-git-send-email-joerg.roedel@amd.com>
	<6d716497-bcf6-4d71-88a3-6ec772a4d396@sausexedgep01.amd.com>
	<20121001084051.GO4009@amd.com>
	<20121001134753.GF4099@phenom.dumpdata.com>
	<20121001163338.GP4009@amd.com>
Date: Mon, 1 Oct 2012 12:34:56 -0400
X-Google-Sender-Auth: piExkl3XB2UJeHS0yoc5ynN-e-Y
Message-ID: <CACJDEmqpE_ewzZPuS9OUCOmEHS2HRL66bk0nuTOLd1aMjNu4MQ@mail.gmail.com>
Subject: Re: [PATCH 09/16] iommu/amd: Add IOAPIC remapping routines
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I was thinking the other way around. You recover the old affinity. Should
>> you print out a warning mentioning to the system admin that you could not
>> set the new affinity but reverted to the old one? Or will that not serve
>> anything except spam the kernel logs?
>
> Well, I don't think it makes sense to print an additional error at this
> point. The error will be propagated upwards in the call-chain and in the
> end it is up to the initiator how to handle this situation (for example
> just return a failure to user-space).

OK. Thx for the explanation. I was not sure whether the error would
propagate properly up the chain.
