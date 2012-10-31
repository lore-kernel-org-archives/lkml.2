Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695Ab2JaCmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:42:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48977 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2JaCmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:42:10 -0400
Date: Tue, 30 Oct 2012 19:43:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] zram/zsmalloc promotion
Message-ID: <20121031024307.GA9210@kroah.com>
References: <1351501009-15111-1-git-send-email-minchan@kernel.org>
 <20121031010642.GN15767@bbox>
 <20121031014209.GB2672@kroah.com>
 <20121031020443.GP15767@bbox>
 <20121031021618.GA1142@kroah.com>
 <20121031023947.GA24883@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031023947.GA24883@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 11:39:48AM +0900, Minchan Kim wrote:
> Greg, what do you think about LTSI?
> Is it proper feature to add it? For it, still do I need ACK from mm developers?

It's already in LTSI, as it's in the 3.4 kernel, right?

