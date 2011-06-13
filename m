Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1FMInd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:43:33 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56614 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1FMIna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:43:30 -0400
Message-ID: <4DF5CDB1.4020103@kernel.dk>
Date: Mon, 13 Jun 2011 10:43:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: Add __attribute__((format(printf...) and fix
 fallout
References: <17ffbd77627a21c05ab9e1a07b5207334291cf01.1307895293.git.joe@perches.com> <5cfffa9f4ffc97d87beb2195cf949eb353f70d7a.1307895296.git.joe@perches.com>
In-Reply-To: <5cfffa9f4ffc97d87beb2195cf949eb353f70d7a.1307895296.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-12 18:21, Joe Perches wrote:
> Use the compiler to verify format strings and arguments.

Thanks, applied.

-- 
Jens Axboe

