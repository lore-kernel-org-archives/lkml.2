Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2EVQ6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:58:54 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:17061 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2EVQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:58:53 -0400
Message-ID: <4FBBC5CB.20201@hp.com>
Date: Tue, 22 May 2012 09:58:51 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: tcp timestamp issues with google servers
References: <87r4ujno34.fsf@tucsk.pomaz.szeredi.hu> <1337278363.3403.39.camel@edumazet-glaptop> <87zk90s0em.fsf@tucsk.pomaz.szeredi.hu> <1337701259.3361.208.camel@edumazet-glaptop> <87mx50rz34.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87mx50rz34.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 08:54 AM, Miklos Szeredi wrote:
> Eric Dumazet<eric.dumazet@gmail.com>  writes:
>
>> On Tue, 2012-05-22 at 17:25 +0200, Miklos Szeredi wrote:
>>
>>> So it appears.  The IP address is certainly registered to Google.
>>
>> Good, but you could have a middlebox doing transparent proxying.
>>
>> The SYNACK could be send by this box.
>
> Okay.  Is there a way to find out whether there is a middlebox or not?

The source IP in the trace was a 192.168 IP - is it possible/desirable 
to reproduce the problem without the device doing NAT in the path?

What is your "public" IP address?  Given that, and the IP address to 
which you are connecting, it should be possible to validate the RTT you 
are seeing.  If the geographic/topological location of the destination 
Google IP address is far enough from your public source IP that would 
show whether  the RTT you are seeing is even physically possible and so 
could suggest there is a middlebox (other than your NAT), though it 
couldn't show there was not a middlebox.


rick jones
