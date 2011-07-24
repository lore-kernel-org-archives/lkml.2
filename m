Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1GXML7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 08:11:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56290
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab1GXMLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 08:11:54 -0400
Date: Sun, 24 Jul 2011 08:11:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Fix wrong return value of xfs_file_aio_write
Message-ID: <20110724121151.GA21871@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
 <4E2B2E88.8080006@redhat.com>
 <20110723203824.GB1652@x4.trippels.de>
 <20110723220212.GA1648@x4.trippels.de>
 <20110724111625.GA12658@infradead.org>
 <20110724115420.GA1626@x4.trippels.de>
 <20110724115826.GB1626@x4.trippels.de>
 <20110724120330.GC1626@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724120330.GC1626@x4.trippels.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks perfect, thanks a lot !

