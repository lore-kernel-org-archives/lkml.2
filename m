Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2DSIFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:05:00 -0400
Received: from host188-6-static.238-77-b.business.telecomitalia.it ([77.238.6.188]:51451
	"EHLO max.ctrix.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab2DSIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:04:48 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 04:04:48 EDT
X-NM-Malware-Status: Clean
X-NM-Auth: m.cetra@ctrix.it
Message-ID: <4F8FC5AF.7020403@navynet.it>
Date: Thu, 19 Apr 2012 09:58:39 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111120 Icedove/3.1.16
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: "Peter Huang (Peng)" <peter.huangpeng@huawei.com>, shemminger@vyatta.com,
        "'David S. Miller'" <davem@davemloft.net>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        ctrix+debianbugs@navynet.it, peter.huangpeng@gmail.com,
        harry.majun@huawei.com
Subject: Re: [PATCH] set fake_rtable's dst to NULL to avoid kernel Oops.
References: <000001cd1c62$75d10de0$617329a0$%huangpeng@huawei.com> <20120418190450.GA30185@burratino>
In-Reply-To: <20120418190450.GA30185@burratino>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/2012 21:04, Jonathan Nieder wrote:
>
> Massimo Cetra (cc-ed) tested the patch against a 3.2.y kernel and wrote[1]:
>
>> The patch i applied yesterday to the debian kernel has been installed
>> and the kernel is not panic-ing anymore.
>>
>> I'll try to keep this bug up to date.
>
> So it seems to work.  Dave, please consider queuing this for stable@
> when the final patch is ready.

Also please consider that the bridge problems are not over and the 
kernel keeps panicing in a different way...

- http://marc.info/?t=133474395500004&r=1&w=2

Thanks,
Massimo


