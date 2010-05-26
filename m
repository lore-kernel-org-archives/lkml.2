Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0EZPn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:43:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42507 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0EZPnz (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 26 May 2010 11:43:55 -0400
Date: Wed, 26 May 2010 11:42:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       albert_herranz@yahoo.es, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org
Subject: Re: [PATCH] swiotlb v0.8: seperation of physical/virtual address
	translation
Message-ID: <20100526154206.GA29139@phenom.dumpdata.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <20100517185011X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517185011X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BFD41A7.0096:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 06:48:35PM +0900, FUJITA Tomonori wrote:
> On Tue, 11 May 2010 11:39:07 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8
> > 
> >  include/linux/swiotlb.h |   27 ++++++++-
> >  lib/swiotlb.c           |  140 ++++++++++++++++++++++++++++-------------------
> >  2 files changed, 108 insertions(+), 59 deletions(-)
> 
> I think that the 5th and 6th should be fold. But the rest (with the

Will do.
> following fixes) looks fine to me. I'm not sure how you send this to

Thank you for patience and taking the time to review them.
Sorry about answering so late - just got back from vacation.

> upstream, however, seems that the patchset conflicts with the swiotlb
> changes in -mm.

Oh, let me investigate and have a patch-set ready against -mm as well.
