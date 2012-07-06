Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2GFS2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:28:21 -0400
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:57985 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2GFS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:28:19 -0400
Message-ID: <4FF72E15.1010703@genband.com>
Date: Fri, 06 Jul 2012 12:27:33 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>
CC: Vincent Sanders <vincent.sanders@collabora.co.uk>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk> <20120629.153656.1141845894730637434.davem@davemloft.net> <20120629231236.GA28593@mail.collabora.co.uk> <alpine.LNX.2.01.1207052242450.2202@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1207052242450.2202@frira.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2012 18:27:39.0490 (UTC) FILETIME=[062C2420:01CD5BA5]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19024.001
X-TM-AS-Result: No--8.088800-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Saturday 2012-06-30 01:12, Vincent Sanders wrote:
>> Firstly it is intended is an interprocess mechanism and not to rely on
>> a configured IP system, indeed one of its primary usages is to
>> provide mechanism for various tools to set up IP networking.
> Using IP as a localhost IPC is not uncommon (independent of
> software preferring AF_UNIX, if so available). Distro boot
> scripts have been running `ip addr add ::1/128 dev lo`
> all these years along.
>
> And now we suddently need a DBUS program just to configure
> IP-based localhost IPC? I can see the flaw in that.
>

I haven't tried it in a while but it used to be that you couldn't use IP 
multicast on the "lo" device.  Has that been fixed?

Chris
