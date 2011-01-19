Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1ASReH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:34:07 -0500
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:42930 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab1ASReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:34:05 -0500
Message-ID: <4D37207F.5070809@genband.com>
Date: Wed, 19 Jan 2011 11:33:51 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Martin Volf <martin.volf.42@gmail.com>
CC: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tool to send unsolicited neighbour advertisements?
References: <4D35FB33.1080305@genband.com> <AANLkTi=g-tSrLMmu4JuuKrze4SJD67CSmbS3aONBw7wV@mail.gmail.com>
In-Reply-To: <AANLkTi=g-tSrLMmu4JuuKrze4SJD67CSmbS3aONBw7wV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2011 17:33:53.0004 (UTC) FILETIME=[0A72F2C0:01CBB7FF]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17904.000
X-TM-AS-Result: No--14.610000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 03:42 AM, Martin Volf wrote:
> On 18 January 2011 21:42, Chris Friesen <chris.friesen@genband.com> wrote:
>> We're transitioning stuff to IPv6 and I've been trying (without much
>> luck) to find a standard tool for sending out unsolicited neighbour
>> advertisements for failover purposes.
>> Is there such a thing?  In ipv4 arping works fine.
> 
> Hello,
> 
> probably http://www.remlab.net/ndisc6/

The ndisc6 tool appears to do neighbour discovery, but doesn't have any
options that I could see to send unsolicited neighbour advertisements.

There are various blackhat-type tools to do this, but I haven't been
able to find a real ipv6 replacement for arping.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
