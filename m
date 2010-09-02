Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0IBGv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:51:56 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:58719 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751484Ab0IBGvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:51:55 -0400
X-QQ-mid: esmtp4t1283410311t157t9016
X-QQ-SSF: 0000000000000010F16200000000000
Message-ID: <4C7F4984.1060703@qq.com>
Date: Thu, 02 Sep 2010 14:51:48 +0800
From: gaoqiang <834555262@qq.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: dear list
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a newbie and got some question when learning the linux kernel

about a macro:

page_to_pfn(pg)

I traced its definition,and finally got that:

#define __page_to_pfn(page) ((unsigned long)((page) - mem_map) + 
ARCH_PFN_OFFSET)


why hot ((unsigned long)((page)-mem_map + ARCH_PFN_OFFSET)/sizeof 
(struct page)


