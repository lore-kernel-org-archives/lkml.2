Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0HWK03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:26:29 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:32958 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab0HWK01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:26:27 -0400
Message-ID: <4C724CD4.9010004@fusionio.com>
Date: Mon, 23 Aug 2010 12:26:28 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: cfq-iosched: Implement group idling and
 IOPS  accounting for groups V4
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-12 00:44, Vivek Goyal wrote:
> 
> Hi,
> 
> This is V4 of the patches for group_idle and CFQ group charge accounting in
> terms of IOPS implementation. Since V3 not much has changed. Just more testing
> and rebase on top of for-2.6.36 branch of block tree.

Thanks Vivek, I have applied the patches.

-- 
Jens Axboe

