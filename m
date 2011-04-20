Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1DTGse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:48:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64581 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1DTGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:48:33 -0400
Message-ID: <4DAE81ED.9060505@cn.fujitsu.com>
Date: Wed, 20 Apr 2011 14:49:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: allocate extent state and check the result
 properly
References: <4DA409E6.7020406@cn.fujitsu.com> <4DACEA40.5020008@cn.fujitsu.com> <1303213987-sup-4275@think>
In-Reply-To: <1303213987-sup-4275@think>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 14:49:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 14:49:04,
	Serialize complete at 2011-04-20 14:49:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 07:55 PM, Chris Mason wrote:

> Sorry, could you please change this to check the results of the atomic
> allocatoin in set/clear_extent_bit?  I'd rather not add a new BUG_ON
> deeper into the code.
> 

OK, i have posted the v2 patch to fix it, thanks for your review!
