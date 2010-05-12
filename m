Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0ELTiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:38:50 -0400
Received: from dm-mail02.mozilla.org ([63.245.208.176]:37012 "EHLO
	dm-mail02.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab0ELTit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:38:49 -0400
Message-ID: <4BEB03B6.6080706@mozilla.com>
Date: Wed, 12 May 2010 12:38:30 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: How to use perf to log page faults
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 From the docs it seems that perf may be useful for logging page faults. 
I tried
perf record -g -d -f -e page-faults <mycommand>
but all I got were PERF_RECORD_MMAP events.

I'm using 2.6.32. Ideally I'd like to collect fault addresses and 
userspace stacks that caused them. Isn't this what the page-fault event 
is for?

Taras
