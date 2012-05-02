Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2EBSQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:16:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50210 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2EBSQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:16:58 -0400
Message-ID: <4FA17A15.7050602@gmail.com>
Date: Wed, 02 May 2012 14:16:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ulrich Drepper <drepper@akkadia.org>
CC: arnd@arndb.de, davem@davemloft.net, fengguang.wu@intel.com,
        hch@infradead.org, hverkuil@xs4all.nl, kosaki.motohiro@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: [PATCH v2] Install kernel-page-flags.h
References: <201205021440.q42Ee9Ki026894@drepperk.user.openhosting.com>
In-Reply-To: <201205021440.q42Ee9Ki026894@drepperk.user.openhosting.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/2/12 10:40 AM), Ulrich Drepper wrote:
> Programs using /proc/kpageflags need to know about the various flags.  The
> <linux/kernel-page-flags.h>  provides them and the comments in the file
> indicate that it is supposed to be used by user-level code.  But the file
> is not installed.
> 
> The patch below installs the headers and marks the unstable flags as
> out-of-bounds.  The page-type tool is also adjusted to not duplicate the
> definitions
> 
> 
> Signed-off-by: Ulrich Drepper<drepper@gmail.com>

Thank you.
 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


