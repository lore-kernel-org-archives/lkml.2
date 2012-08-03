Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2HCFL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:11:26 -0400
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:38256 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2HCFLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:11:23 -0400
Message-ID: <501B5D51.5030307@genband.com>
Date: Thu, 02 Aug 2012 23:10:41 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: dmarkh@cfl.rr.com
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE("GPL")??
References: <50199E91.5040308@cfl.rr.com> <20120801224342.5b90747f@pyramind.ukuu.org.uk> <501A704E.2000301@cfl.rr.com>
In-Reply-To: <501A704E.2000301@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2012 05:10:43.0212 (UTC) FILETIME=[550424C0:01CD7136]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19082.002
X-TM-AS-Result: No--8.355700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:19 AM, Mark Hounschell wrote:
>
> This particular driver  does in fact build cleanly after changing the 
> GPL to PROPRIETARY. I haven't actually purchased the product yet so am 
> unable to load it, but can I assume that if I don't have a build issue 
> when specifying PROPRIETARY, that they are in fact NOT using GPL 
> symbols and maybe they just thought they needed to specify GPL for 
> some reason or another?

Why not just ask the authors?

Chris
