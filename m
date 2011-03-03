Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1CCTyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:54:49 -0500
Received: from lotus.nuim.ie ([149.157.1.189]:57771 "EHLO lotus.nuim.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533Ab1CCTys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:54:48 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 14:54:48 EST
Message-id: <4D6FEFD4.9010608@nuim.ie>
Date: Thu, 03 Mar 2011 13:45:24 -0600
From: Tianji Li <Tianji.Li@nuim.ie>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430
 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-version: 1.0
To: rick.jones2@hp.com
Cc: =?ISO-8859-1?Q?Dave_T=E4ht?= <d@taht.net>, sedat.dilek@gmail.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        bloat-devel@lists.bufferbloat.net, linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
References: <20110225222210.GA3618@tuxdriver.com>
 <AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
 <87fwr9jxya.fsf@cruithne.co.teklibre.org>
 <AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
 <8739n9ii7z.fsf@cruithne.co.teklibre.org>
 <AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
 <87tyfph2az.fsf@cruithne.co.teklibre.org> <1299176168.2157.14.camel@tardy>
In-reply-to: <1299176168.2157.14.camel@tardy>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/03/2011 12:16 PM, Rick Jones wrote:
>> For wireless routers and cable home gateways especially, this research
>> shows that the total un-managed buffers in your system should be less
>> than 32.
>
> Would it be a good thing to start describing these queues not so much in
> terms of packets but in terms of delay (or bandwidth X delay)?
>

The unit of bandwidth is something like Mbps, that of delay can be 
second, so bandwidth X delay --> Mb, which is the unit of packet size. 
So both packets and delay should have the same effect for sizing buffers.

Tianji



> Constants tend to live longer than they should, no matter how noble in
> birth.
>
> rick jones
>
> _______________________________________________
> Bloat-devel mailing list
> Bloat-devel@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/bloat-devel
>
