Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125Ab2FVDrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:47:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36058 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761078Ab2FVDrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:47:19 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [patch 1/2]block: handle merged discard request
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<4F69C62C.7020604@kernel.org> <yq18vitwejt.fsf@sermon.lab.mkp.net>
	<CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
	<yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
	<20120620085724.GA26295@infradead.org>
Date: Thu, 21 Jun 2012 23:46:56 -0400
In-Reply-To: <20120620085724.GA26295@infradead.org> (Christoph Hellwig's
	message of "Wed, 20 Jun 2012 04:57:24 -0400")
Message-ID: <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> There are several additional commands in the pipeline where the 1:1
>> mapping between DMA size and block range is invalid. I want to get
>> rid of the 1:1 assumption in general so we can handle any command
>> without these evil workarounds.

Christoph> What's the progress on getting these issues sorted out?

This has bitrotted for a while. I'll put it on my list. I should finally
have some bandwidth again next week...

-- 
Martin K. Petersen	Oracle Linux Engineering
