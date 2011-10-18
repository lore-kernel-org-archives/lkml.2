Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab1JRNPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:15:09 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3354 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab1JRNPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:15:06 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4E9D7BCD.1050104@broadcom.com>
Date: Tue, 18 Oct 2011 15:14:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111017@schottelius.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <20111018111422.GA1979@schottelius.org>
In-Reply-To: <20111018111422.GA1979@schottelius.org>
X-Enigmail-Version: 1.1.2
OpenPGP: id=B5E1A116
X-WSS-ID: 6283A2ED5IS20013142-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 01:14 PM, Nico Schottelius wrote:
> Dear LKML,

In this case linux-wireless list may be more appropriate, adding it.

> The hardware is again the (in)famous MacBook Air 4,2, so I imagine this may be
> related to brcmsmac.
> 
> Attached are config, dmesg, lsmod.

In the dmesg I see a lot of PM messages. Did you do a suspend/resume or
hibernate? Trying to determine the scenario so any more info is appreciated.

> 
> Cheers,
> 
> Nico
> 

Gr. AvS

