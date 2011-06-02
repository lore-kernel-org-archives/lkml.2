Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab1FBLGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:06:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33840 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1FBLF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:05:58 -0400
Message-ID: <4DE76E96.1060704@kernel.dk>
Date: Thu, 02 Jun 2011 13:05:58 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bogus check in queue_fail path
References: <1306956887.9926.3.camel@t41.thuisdomein>
In-Reply-To: <1306956887.9926.3.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 21:34, Paul Bolle wrote:
> queue_fail can only be reached if cic is NULL, so its check for cic must
> be bogus.

Indeed, cic is always NULL at that point. Applied.

-- 
Jens Axboe

