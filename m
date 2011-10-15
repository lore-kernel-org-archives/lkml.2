Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1JOSgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:36:36 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4185 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1JOSge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:36:34 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E99D2A2.7030000@broadcom.com>
Date: Sat, 15 Oct 2011 20:36:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.1-rc9 wifi problem
References: <web-626864831@zbackend1.aha.ru>
In-Reply-To: <web-626864831@zbackend1.aha.ru>
X-Enigmail-Version: 1.1.2
OpenPGP: id=B5E1A116
X-WSS-ID: 62870BDE3JW5845888-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2011 08:07 PM, werner wrote:
> A laptop of a friend, which worked always with wifi until 
> 3.0.4 , stopped to work when installing 3.1-rc9 , after 
> re-installing 3.0.4 wifi returned to work.  I think it was 
> a packard-bell laptop.   I can't test this better because 
> he gone with his laptop; perhaps next week he'll visit me 
> again. Since 2.6.38 his laptop worked with my wifi.
> 
> This can be a regression in the wifi drivers, or because 
> of a slightly changed config. Anyway the diff of config is 
> enclosed.
> 
> w.landgraf
> ---
> Professional hosting for everyone - http://www.host.ru

Hi Werner,

"wifi" is a bit too generic and "think it was a packard-bell" is vague
so not helping either. At least provide some basic info 1) uname -a, and
2) lspci -v. Or is the "wifi" a usb device? Also the 3.1.0-rc9 config
and not just the diff can help (which says 3.1.0-rc8?).

Gr. AvS

