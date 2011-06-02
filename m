Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab1FBLFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:05:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1FBLFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:05:40 -0400
Message-ID: <4DE76E82.1090808@kernel.dk>
Date: Thu, 02 Jun 2011 13:05:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use hlist_entry() for io_context.cic_list.first
References: <1306956828.9926.2.camel@t41.thuisdomein>
In-Reply-To: <1306956828.9926.2.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 21:33, Paul Bolle wrote:
> list_entry() and hlist_entry() are both simply aliases for
> container_of(), but since io_context.cic_list.first is an hlist_node one
> should at least use the correct alias.

Thanks, that does look cleaner.

-- 
Jens Axboe

