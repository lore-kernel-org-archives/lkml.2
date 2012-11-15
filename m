Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768623Ab2KOSDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:03:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768597Ab2KOSDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:03:05 -0500
Message-ID: <1353002574.32296.1.camel@t520.localdomain>
Subject: Re: [PATCH RFT RESEND linux-next] c6x: dma-mapping: support
 debug_dma_mapping_error
From: Mark Salter <msalter@redhat.com>
To: shuah.khan@hp.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, a-jacquiot@ti.com,
        linux-c6x-dev@linux-c6x.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 13:02:54 -0500
In-Reply-To: <1353001500.2532.29.camel@lorien2>
References: <1351206082.6851.6.camel@lorien2>
	 <1351266055.4013.1.camel@lorien2> <1351874655.2721.16.camel@lorien2>
	 <1351883445.15973.24.camel@deneb.redhat.com>
	 <1351885999.3161.11.camel@lorien2>
	 <1351887326.15973.35.camel@deneb.redhat.com>
	 <1351887967.3161.17.camel@lorien2>
	 <1351889957.15973.43.camel@deneb.redhat.com>
	 <1351890491.3161.23.camel@lorien2> <1353001500.2532.29.camel@lorien2>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 10:45 -0700, Shuah Khan wrote:
> This is for c6x to go through Marek's tree with all the other arch
> patches. Hope that is ok with you Mark.
> 
> https://lkml.org/lkml/2012/11/3/219 fixes the
> debug_dma_mapping_error()
> dependency on get_dma_ops() that caused compile errors on c6x.

Yes.

Acked-by: Mark Salter <msalter@redhat.com>


