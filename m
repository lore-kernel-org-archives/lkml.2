Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab2HINU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:20:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:59480 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2HINU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:20:26 -0400
Message-ID: <5023B8FC.90800@kernel.dk>
Date: Thu, 09 Aug 2012 15:19:56 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, vgoyal@redhat.com, neilb@suse.de
Subject: Re: [RFC]block: disable discard request merge temporarily
References: <20120809052803.GA11814@kernel.org>
In-Reply-To: <20120809052803.GA11814@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 07:28 AM, Shaohua Li wrote:
> The SCSI discard request merge never worked, and looks no solution for in
> future, let's disable it temporarily.

Thanks, applied!

-- 
Jens Axboe

