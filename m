Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2INOKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:10:52 -0400
Received: from huecha.unizar.es ([155.210.1.51]:58594 "EHLO huecha.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab2INOKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:10:51 -0400
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2012 10:10:50 EDT
Message-ID: <5053330E.80003@ono.com>
Date: Fri, 14 Sep 2012 15:37:18 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120909 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Inconsistency in /proc/cpuinfo about topology ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

Probably there is something I don't understand, but it looks to me like an
inconsistency in the info given by /proc/cpuinfo about processor/core/thread
topology.

For new processors, data seems to account for each 'physycal id', all virtual
processors in the same package repeat the same info:
- Core i5:
    physical id	: 0
    siblings	: 4
    cpu cores	: 4
- Core i3:
    physical id	: 0
    siblings	: 4
    cpu cores	: 2
- Dual Xeon X5365
    physical id	: 0
    siblings	: 4
    cpu cores	: 4
    physical id	: 1
    siblings	: 4
    cpu cores	: 4
- Core Q9450
    physical id	: 0
    siblings	: 4
    cpu cores	: 4

but for older CPUs or lower end it is not the same:
- Dual P4-Xeon:
    physical id	: 0
    siblings	: 1
    cpu cores	: 1
    physical id	: 0
    siblings	: 1
    cpu cores	: 0
    physical id	: 3
    siblings	: 1
    cpu cores	: 1
    physical id	: 3
    siblings	: 1
    cpu cores	: 0

- Single P4 HT:
    physical id	: 0
    siblings	: 1
    cpu cores	: 1
    physical id	: 0
    siblings	: 1
    cpu cores	: 0

What am I missing ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
