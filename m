Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2HCFN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:13:28 -0400
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:35007 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HCFN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:13:26 -0400
Message-ID: <501B5DAC.7070400@genband.com>
Date: Thu, 02 Aug 2012 23:12:12 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: leroy christophe <christophe.leroy@c-s.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Huge performance degradation for UDP between 2.4.17 and 2.6
References: <501A722D.1070900@c-s.fr>
In-Reply-To: <501A722D.1070900@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2012 05:12:13.0523 (UTC) FILETIME=[8AD88230:01CD7136]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19082.002
X-TM-AS-Result: No--4.784500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:27 AM, leroy christophe wrote:
> Hi
>
> I'm having a big issue with UDP. Using a powerpc board (MPC860).
>
> With our board running kernel 2.4.17, I'm able to send 160000 voice 
> packets (UDP, 96 bytes per packet) in 11 seconds.
> With the same board running either Kernel 2.6.35.14 or Kernel 3.4.7, I 
> need 55 seconds to send the same amount of packets.
>
>
> Is there anything to tune in order to get same output rate as with 
> Kernel 2.4 ?

Have you tried profiling it to see where the time is being spent?  Also 
turning off any unnecessary features, debugging, etc?

Chris
