Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1GKT4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:56:25 -0400
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:45968 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1GKT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:56:24 -0400
Message-ID: <4E1B5544.5000207@genband.com>
Date: Mon, 11 Jul 2011 13:55:48 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: loody <miloody@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to find a task through name faster?
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>	<CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>	<4E1B3816.2030606@genband.com> <CANudz+vvXrw=4+tk6z8GW+2rW-ZsogN0XGcozLSyY-dJ_SoHdw@mail.gmail.com>
In-Reply-To: <CANudz+vvXrw=4+tk6z8GW+2rW-ZsogN0XGcozLSyY-dJ_SoHdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2011 19:55:48.0885 (UTC) FILETIME=[87C60450:01CC4004]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18254.001
X-TM-AS-Result: No--10.562000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 11:57 AM, loody wrote:
> 2011/7/12 Chris Friesen<chris.friesen@genband.com>:

>> The names of tasks isn't indexed in any way so the above is about as good as
>> it gets if that's all the information you have.
>
> actually, I only have the name for searching, since the thread start
>   and finish periodically, pid of it will change dynamically. If I save
> the pid, next time it will change and be no use to me

If this is critical to your system performance you could customize the 
kernel to do some sort of indexing based on the name.  This would 
involve a bit more work on task startup/shutdown and when the name is 
changed, but it would make it faster to search for a task by name.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
