Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1LUQlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:41:46 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:46509 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1LUQlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:41:44 -0500
Message-ID: <4EF20C40.3060909@criticallink.com>
Date: Wed, 21 Dec 2011 11:41:36 -0500
From: Michael Williamson <michael.williamson@criticallink.com>
Organization: Critical Link, LLC
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Michael Williamson <michael.williamson@criticallink.com>
CC: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de
Subject: Re: [PATCH] regmap: fix return value in regcache-indexed read call.
References: <1324482482-30889-1-git-send-email-michael.williamson@criticallink.com>
In-Reply-To: <1324482482-30889-1-git-send-email-michael.williamson@criticallink.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 10:48 AM, Michael Williamson wrote:
> The regcache_read() API for regmap requires a 0 return value for
> successful cached reads.  The read method for the indexed type
> cache implementation is returning the positive map offset for a
> successful read, which is incorrect.  Fix it.
>
[...]

Looks like this cache type is due to be removed in linux-next.  Please
withdraw.  Thanks.

http://permalink.gmane.org/gmane.linux.kernel/1217338

-Mike
