Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1JVIpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 04:45:04 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1478 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab1JVIpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 04:45:03 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4EA2827E.1030502@broadcom.com>
Date: Sat, 22 Oct 2011 10:44:46 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Greg KH" <gregkh@suse.de>
cc: "Nico Schottelius" <nico-linux-20111017@schottelius.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <1319028563.8416.1.camel@edumazet-laptop>
 <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org> <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org> <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org> <4E9FBFA7.4040502@broadcom.com>
 <20111022015945.GC26186@ethz.ch>
 <400C43189542CE41BC0A5B252FC90136BC0E147BCB@SJEXCHCCR02.corp.ad.broadcom.com>
 <20111022083005.GA6032@suse.de>
In-Reply-To: <20111022083005.GA6032@suse.de>
X-Enigmail-Version: 1.1.2
OpenPGP: id=B5E1A116
X-WSS-ID: 62BC5B8C0EG3497344-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2011 10:30 AM, Greg KH wrote:
> On Sat, Oct 22, 2011 at 01:13:34AM -0700, Arend Van Spriel wrote:
>>> From: Nico Schottelius [mailto:nico-linux-20111017@schottelius.org]
>>> Sent: zaterdag 22 oktober 2011 4:00
>>>
>>> Hey Arend,
>>>
>>> it seems that your patch really solves this problem.
>>
>> Great. This fix is in linux-next tree.
>>
>> Greg,
>>
>> This problem causes packets to get dropped on 5GHz. Should I
>> sent a patch for 3.1 (staging-linus) for this? It is already
>> fixed in wireless-next.
> 
> No, just wait for it to get into Linus's tree for 3.2-rc1, and then
> email the git commit id to stable@vger.kernel.org so it will be added to
> the 3.1-stable releases.
> 
> greg k-h
> 

Thanks, Greg

Saw you email regarding staging-next so I was not sure about
staging-linus. Will be patient ;-)

Gr. AvS

