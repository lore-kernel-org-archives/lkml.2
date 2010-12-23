Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0LXArI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:47:08 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:58052 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0LXArH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:47:07 -0500
X-Greylist: delayed 3006 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2010 19:47:07 EST
MIME-Version: 1.0
Date: Thu, 23 Dec 2010 17:56:58 -0600
From: Felipe Balbi <me@felipebalbi.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, <Eric.Valette@Free.fr>,
        lud <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
In-Reply-To: <Pine.LNX.4.44L0.1012231755180.11535-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1012231755180.11535-100000@netrider.rowland.org>
Message-ID: <36f50535272fab60e974dc75e172bf29@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 23 Dec 2010 17:57:52 -0500 (EST), Alan Stern
<stern@rowland.harvard.edu> wrote:
> On Thu, 23 Dec 2010, Randy Dunlap wrote:
> 
>> [add linux-usb list]
>> 
>> 
>> On Thu, 23 Dec 2010 10:55:38 +0100 Eric Valette wrote:
>> 
>> > I have the following messages:
>> > 
>> > Will now halt
>> > hub:4-0:1.0: hub_port_status_failed (err 110)

I've got an E6400 myself and the only time I could get
it to hang was when trying to use brcm80211 driver from
staging. The problem appears when I rmmod/modprobe the
driver after it looses connection to my wifi router.

Since the driver is still in staging and buggy as hell
I didn't bother notifying anyone. But it's true that
shutdown truly hangs.

Are you using brcm80211 driver too ?

-- 
balbi
