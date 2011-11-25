Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1KYImT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:42:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1KYImS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:42:18 -0500
Message-ID: <4ECF54E6.90501@kernel.dk>
Date: Fri, 25 Nov 2011 09:42:14 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]loop: fix loop block driver comment
References: <20111125082910.GA2661@darkstar.nay.redhat.com>
In-Reply-To: <20111125082910.GA2661@darkstar.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-25 09:29, Dave Young wrote:
> loop driver do not support discard if encryption is enabled, fix the comment.

Thanks Dave, applied.

-- 
Jens Axboe

