Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2BGGz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:55:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53615 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2BGGz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:55:56 -0500
Message-ID: <4F30CAB7.3030104@kernel.dk>
Date: Tue, 07 Feb 2012 07:54:47 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: Re: [PATCH v2 resend] mtip32xx: removed the irrelevant argument of
 mtip_hw_submit_io() and the unused member of struct driver_data
References: <4F3096C3.7090100@micron.com>
In-Reply-To: <4F3096C3.7090100@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 04:15 AM, Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2] wrote:
> Resending the patch in plain text format. 
> 
> From: Asai Thambi S P <asamymuthupa@micron.com>
> 
> Removed the following:
> 	* irrelevant argument 'barrier' of mtip_hw_submit_io()
> 	* unused member 'eh_active' of struct driver_data

Thanks, applied.

-- 
Jens Axboe

