Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0EKSza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:55:30 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:33903 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0EKSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:55:28 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] ibft: Update iBFT handling for v1.03 of the spec.
Date: Tue, 11 May 2010 13:58:57 -0400
User-Agent: KMail/1.9.10
References: <1270822888-13192-1-git-send-email-konrad@kernel.org> <1270822888-13192-2-git-send-email-konrad@kernel.org> <20100421142634.ea5ca8a5.akpm@linux-foundation.org>
In-Reply-To: <20100421142634.ea5ca8a5.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org,
       Peter Jones <pjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005111358.58413.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
> > Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
>
> This should have Peter's Signed-off-by:, please.
>
Done.
> > ...
> >
> > +#ifdef CONFIG_ACPI
> > +static int __init acpi_find_ibft(struct acpi_table_header *header)
> > +{
> > +	ibft_addr = (struct acpi_table_ibft *)header;
>
> container_of() would be better here.  And maybe elsewhere, too.

Actually there is no need for that. We are just casting it, not getting any 
internal member.
