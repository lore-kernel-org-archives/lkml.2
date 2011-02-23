Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1BWTdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:33:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab1BWTdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:33:03 -0500
Subject: Re: [PATCH v2 0/2] intel-iommu: Fix domain_ids exhaustion
From: Alex Williamson <alex.williamson@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        ddutile@redhat.com, chrisw@redhat.com
In-Reply-To: <20110218003828.GA991@khazad-dum.debian.net>
References: <20110216203204.2979.13203.stgit@s20.home>
	 <20110218003828.GA991@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 12:32:06 -0700
Message-ID: <1298489526.18387.58.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 22:38 -0200, Henrique de Moraes Holschuh wrote:
> Once merged, should it go to -stable?  If so, maybe it would be a good
> idea to add that while collecting the Acked-By's...

Yeah, I think this would be a valid -stable candidate.  I'm hoping we'll
get an Ack from David here soon...

Alex

