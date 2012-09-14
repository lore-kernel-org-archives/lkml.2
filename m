Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab2INXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 19:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab2INXJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 19:09:27 -0400
Date: Sat, 15 Sep 2012 00:09:14 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>,
        bharrosh@panasas.com, tj@kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH 2] dm: Use bioset's front_pad for
	dm_target_io
Message-ID: <20120914230914.GR15728@agk-dp.fab.redhat.com>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Kent Overstreet <koverstreet@google.com>,
	Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	"Alasdair G. Kergon" <agk@redhat.com>, bharrosh@panasas.com,
	tj@kernel.org, Vivek Goyal <vgoyal@redhat.com>
References: <20120829171345.GC20312@google.com> <20120830220745.GI27257@redhat.com> <20120831014359.GB15218@moria.home.lan> <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com> <20120904034100.GA21602@moria.home.lan> <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com> <20120904195156.GE25236@google.com> <Pine.LNX.4.64.1209111349210.23947@file.rdu.redhat.com> <20120911195029.GJ19739@google.com> <Pine.LNX.4.64.1209121831110.21106@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209121831110.21106@file.rdu.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 06:31:53PM -0400, Mikulas Patocka wrote:
> This is the patch based on this tree.
 
I've pulled this into the dm tree for now.

Alasdair

