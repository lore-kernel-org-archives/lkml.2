Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1EIGeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:34:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:32878 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1EIGeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:34:09 -0400
Message-ID: <4DC78ADD.6010503@kernel.dk>
Date: Mon, 09 May 2011 08:34:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the block tree
References: <20110509134931.6d822e05.sfr@canb.auug.org.au> <1304920537-3975-1-git-send-email-tm@tao.ma>
In-Reply-To: <1304920537-3975-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-09 07:55, Tao Ma wrote:
> Hi Jens,
> 
> Sorry for the trouble. Here is the fix.

Already fixed it up, we don't need a cast at all.

-- 
Jens Axboe

