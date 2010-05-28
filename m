Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0E1FYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:24:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46044 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0E1FYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:24:04 -0400
Message-ID: <4BFF5352.8080104@canonical.com>
Date: Fri, 28 May 2010 13:23:30 +0800
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: s.hauer@pengutronix.de, gerg@uclinux.org, amit.kucheria@canonical.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] netdev/fec: fix performance impact from mdio poll
 operation
References: <1273199239-11057-1-git-send-email-bryan.wu@canonical.com>	<1273199239-11057-2-git-send-email-bryan.wu@canonical.com> <20100516.002818.133869940.davem@davemloft.net>
In-Reply-To: <20100516.002818.133869940.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 03:28 PM, David Miller wrote:
> From: Bryan Wu <bryan.wu@canonical.com>
> Date: Fri,  7 May 2010 10:27:18 +0800
> 
>> BugLink: http://bugs.launchpad.net/bugs/546649
>> BugLink: http://bugs.launchpad.net/bugs/457878
>>
>> After introducing phylib supporting, users experienced performace drop. That is
>> because of the mdio polling operation of phylib. Use msleep to replace the busy
>> waiting cpu_relax() and remove the warning message.
>>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> Acked-by: Andy Whitcroft <apw@canonical.com>
> 
> As you've already been told, making these MDIO interfaces fail silently
> is not acceptable.
> 
> Please fix this bug properly and resubmit this patch series.
> 

So sorry for the delay. My board's broken for several weeks. After I got a new,
I will try to fix this and resubmit this patch.

Thanks
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team | Hardware Enablement Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
