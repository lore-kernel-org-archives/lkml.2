Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1BPP4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:56:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16462 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1BPP4G (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Feb 2011 10:56:06 -0500
Date: Wed, 16 Feb 2011 10:54:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, konrad@darnok.org
Subject: Re: [PATCH 4/5] radeon/ttm/PCIe: Use dma_addr if TTM has set it.
Message-ID: <20110216155422.GA4056@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <1294420304-24811-5-git-send-email-konrad.wilk@oracle.com>
 <20110127212001.GC4542@dumpdata.com>
 <AANLkTimKgfKwtWpXBvTGmJbW-2uGhV+7nMahsScUM0pr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimKgfKwtWpXBvTGmJbW-2uGhV+7nMahsScUM0pr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D5BF333.01CE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Code looks good but GART stuff can be picky, i will try to do a full
> scale testing in next couple week.

ping?
