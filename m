Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0GZONe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:13:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0GZONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:13:33 -0400
Date: Mon, 26 Jul 2010 10:13:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100726141330.GA1621@infradead.org>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724080613.GA6554@fancy-poultry.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious, what numbers do you see when simply using the deadline
I/O scheduler?  That's what we recommend for use with XFS anyway.

