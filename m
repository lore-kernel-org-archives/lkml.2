Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2DDH0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:26:05 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:63246 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab2DDH0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:26:03 -0400
Message-ID: <4F7BF785.9060205@permonline.ru>
Date: Wed, 04 Apr 2012 13:25:57 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Ethernet drivers for WIZnet chips
References: <1332752876-1650-1-git-send-email-msink@permonline.ru> <1333450726-24455-1-git-send-email-msink@permonline.ru> <1333453170.18626.65.camel@edumazet-glaptop> <4F7AE9D3.80204@permonline.ru> <1333456156.18626.93.camel@edumazet-glaptop> <4F7BE30B.9020603@permonline.ru> <1333520260.18626.383.camel@edumazet-glaptop>
In-Reply-To: <1333520260.18626.383.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04.04.2012 12:17, Eric Dumazet написал:
> On Wed, 2012-04-04 at 11:58 +0600, Mike Sinkovsky wrote:
>
>> About races - I can't see any, in this very simple procedure.
>> But maybe I missed something..
>
> Maybe post the code and we can help you.

Posted v7.

But - today I don't see tx_timeout(), even if flow control is enabled!
Weird still...

-- 
Mike

