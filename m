Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1HYDdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 23:33:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38243 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1HYDdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 23:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110822.123326.1795268471389412471.davem@davemloft.net>
References: <20110822190136.GJ2534@tuxdriver.com>
	<20110822.123326.1795268471389412471.davem@davemloft.net>
Date: Thu, 25 Aug 2011 11:33:05 +0800
Message-ID: <CAAJw_ZtFw5FxPy+boe_99mKQi7yt3yfGE6FqWrzmUD3T-y1v8w@mail.gmail.com>
Subject: Re: pull request: wireless 2011-08-22
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: David Miller <davem@davemloft.net>, IvDoorn@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 3:33 AM, David Miller <davem@davemloft.net> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 22 Aug 2011 15:01:37 -0400
>
>> This is a batch of fixes intended for 3.1.  Included is rewrite of an
>> earlier iwlagn fix that was revealed to be flawed (bad pointer access
>> during module unload), a fix for a memory leak, and a trio of rt2x00
>> fixes with detailed changelogs.  These have all been in linux-next
>> for the last week with no reported complaints.
>>
>> Please let me know if there are problems!
>
> Pulled, thanks John.

I'm using the rt2800usb module for the Buffalo WLI-UC-GNM using ad-hoc mode.

T:  Bus=01 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0411 ProdID=01a2 Rev= 1.01
S:  Manufacturer=Ralink
S:  Product=802.11 n WLAN

It works ok, but after idling for a while, it does not response, and
module needs to unloaded and modprobe again to make it work.

The same mac80211 and cfg80211 works for iwlagn and no problem with
idling timeout.

Is there any parameter to control the rt2800usb to make turn off power saving?

I've tried "iwconfig lwan0 power timeout 0 power off" but no effect.

Linux 3.1.0-rc3 with commit caca9510ff4e5d842c0589110243d60927836222.

Thanks,
Jeff.
