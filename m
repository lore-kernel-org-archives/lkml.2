Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1JTG3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:29:12 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1383 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab1JTG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:29:10 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E9FBFA7.4040502@broadcom.com>
Date: Thu, 20 Oct 2011 08:28:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111017@schottelius.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
 <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org> <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org> <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org>
In-Reply-To: <20111019214250.GC2432@schottelius.org>
X-Enigmail-Version: 1.1.2
OpenPGP: id=B5E1A116
X-WSS-ID: 62811ED43JW7488640-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 11:42 PM, Nico Schottelius wrote:
> 
> I'll soon (Friday) leave the environment permanently,
> thus testing will not be easily possible anymore.

Let's hope we have a conclusion by then.

> If this issue is 5Ghz related only, can I somehow trigger it without an AP
> running in that band / i.e. make the card try to use the 5 Ghz band although
> there is no ap nearby?
> 
> Cheers,
> 
> Nico
> 

The warning is in the receive path so you need some transmitter to sent
packets to you. So you need the AP. If you can provide 'iwconfig' output
when associated it will tell on which channel it is.

Gr. AvS

