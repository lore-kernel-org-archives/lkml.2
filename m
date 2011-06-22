Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab1FVT7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:59:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53209
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758042Ab1FVT7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:59:18 -0400
Date: Wed, 22 Jun 2011 15:59:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dehrenberg@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/6] DIO: Separate map_bh from dio
Message-ID: <20110622195913.GA24311@infradead.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
 <1308770322-22565-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308770322-22565-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	void *b_private;		/* copy from map_bh.b_private */

Just call it private, please.

