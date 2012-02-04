Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2BDHKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 02:10:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52384 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2BDHKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 02:10:52 -0500
Message-ID: <4F2CD9DB.70501@gmail.com>
Date: Sat, 04 Feb 2012 15:10:19 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, trivial@kernel.org
Subject: Re: [Patch] resource: move EXPORT_SYMBOL right after definition
References: <1328276573-15265-1-git-send-email-xiyou.wangcong@gmail.com> <4F2C088E.3090106@windriver.com>
In-Reply-To: <4F2C088E.3090106@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2012 12:17 AM, Paul Gortmaker wrote:
> On 12-02-03 08:42 AM, Cong Wang wrote:
>> EXPORT_SYMBOL(adjust_resource) should be right after adjust_resource().
>
> Presumably this is to get rid of a checkpatch warning?
> Maybe it makes sense to have it go via the trivial tree?
>

Yeah, although I found this by code review, I agree this is proper for 
trivial.

Thanks.
