Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1CHP7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:59:19 -0500
Received: from kanga.kvack.org ([205.233.56.17]:40339 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1CHP7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:59:14 -0500
X-Greylist: delayed 1849 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Mar 2011 10:59:14 EST
Date: Tue, 8 Mar 2011 10:28:24 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SCSI] mvsas: Add support for HighPoint RR27xx series HBA
Message-ID: <20110308152824.GH5497@kvack.org>
References: <200902121128.31303.linux@highpoint-tech.com> <201102231628.44678.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102231628.44678.linux@highpoint-tech.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

On Wed, Feb 23, 2011 at 04:28:44PM +0800, HighPoint Linux Team wrote:
> This patch is to add support for HighPoint RR27xx SAS/SATA HBA which is based on Marvell 88SE9480 chipset.

Any chance of getting this merged soon?  I've been using a similar patch 
with my HighPoint cards on 2.6.37 for a while now with good results.

		-ben
