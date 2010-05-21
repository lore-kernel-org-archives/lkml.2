Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab0EUSjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:39:10 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:7850 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934101Ab0EUSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:39:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsCAM5u9ktR8hnj/2dsb2JhbAAHgxGOYbl6kGiBJYMDagQ
Message-ID: <4BF6D347.9000107@belbone.be>
Date: Fri, 21 May 2010 20:39:03 +0200
From: =?UTF-8?B?Q8OpZHJpYyBHb2Rpbg==?= <cedric@belbone.be>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100411 Thunderbird/3.0.4
MIME-Version: 1.0
To: jplatte@naasa.net
CC: Joerg Platte <lists@naasa.net>,
       =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <maraeo@gmail.com>,
       dri-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: drm regression on resume with -rc7 (bisected to 797fd5b9dad12a100c81b5782573a41259728cb1)
References: <4BEB0EE6.1060002@belbone.be> <201005182006.45798.lists@naasa.net>
In-Reply-To: <201005182006.45798.lists@naasa.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/10 20:06, Joerg Platte wrote:
> Am Wednesday, 12. May 2010 schrieb Cédric Godin:
> Hi,
>
>    
>> When resuming my laptop from a -rc7, my X session reacted
>>      
> weirdly.
>    
>> Reading the dmesg log, I had :
>>
>> May 12 21:58:03 enea kernel: [  122.627332]
>>      
> [drm:radeon_ib_schedule]
>    
>> *ERROR* radeon: couldn't schedule IB(0).
>> May 12 21:58:03 enea kernel: [  122.627342]
>>      
> [drm:radeon_cs_ioctl]
>
> same problem here with 2.6.34 and Thinkpad T40 (Radeon Mobility
> 7500). The problem appeared after my upgrade to 2.6.34.
> 2.6.33.X does not have this problem. Is there any patch
> available that I can test?
>
> regards,
> Jörg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    
Yes, now there is a patch thanks to Jerome Glisse. I tested it and it's 
working here.
Maybe you could test it too ?

https://bugzilla.kernel.org/attachment.cgi?id=26484

regards,
Cédric
