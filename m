Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab1LPOBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:01:09 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4710 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab1LPOBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:01:00 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4EEB4F09.6080806@broadcom.com>
Date: Fri, 16 Dec 2011 15:00:41 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com> (
 sfid-20111216_102800_182196_AFD2D6CF)
 <1324038636.3429.1.camel@jlt3.sipsolutions.net>
 <4EEB4D61.80602@lwfinger.net>
In-Reply-To: <4EEB4D61.80602@lwfinger.net>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62F58F603GG10253773-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 02:53 PM, Larry Finger wrote:
> 
> I also found that loading brcmsmac did not trigger the license taint. I think 
> you are OK with the dual license.

Ok. I get it upon loading the brcmutil module. Actually, my usage
scenario is:

1) build the driver modules in kernel tree on my development machine.
2) rsync the brcm80211 folder to my test machine.
3) insert the driver modules on my test machine.

> Larry
> 

Gr. AvS

