Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0KKTZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:25:20 -0500
Received: from mail.candelatech.com ([208.74.158.172]:46165 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab0KKTZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:25:19 -0500
Message-ID: <4CDC431E.7080005@candelatech.com>
Date: Thu, 11 Nov 2010 11:25:18 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Difference between VMSPLIT_2G_OPT and VMSPLIT_2G ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried compiling 2.6.37-rc1 with VMSPLIT_2G_OPT, but it seems I'm
still limitted to < 1G of low-memory.  There's no real help for
either this or VMSPLIT_2G.

Should I be seeing more low-memory in /proc/meminfo with one
of these enabled?

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

