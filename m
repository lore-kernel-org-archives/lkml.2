Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1FQP0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:26:48 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:52052 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433Ab1FQP0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:26:44 -0400
Message-ID: <4DFB722A.7040304@free.fr>
Date: Fri, 17 Jun 2011 17:26:34 +0200
From: f6bvp <f6bvp@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110501 Mandriva/3.1.10-0.1mdv2010.2 (2010.2) Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
Subject: Re: [AX25] inconsistent lock state
References: <4B2CD772.1030106@upmc.fr> <20100115203654.GA3084@del.dom.local> <4DFA662D.5030302@free.fr> <201106171536.15660.arnd@arndb.de> <20110617135147.GA3470@linux-mips.org>
In-Reply-To: <20110617135147.GA3470@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

I wanted to check FPAC ROSE application behaviour when Ethernet link was 
shutdown.
To do this I removed the ethernet connector !
I agree this was a very agressive action.

73s de Bernard, f6bvp

Le 17/06/2011 15:51, Ralf Baechle a écrit :
> On Fri, Jun 17, 2011 at 03:36:15PM +0200, Arnd Bergmann wrote:
>
> (Removed Jarek from cc; his email bounces.)
>
>> The message hints that disc_data_lock is aquired with softirqs disabled,
>> but does not itself disable softirqs, which can in rare circumstances
>> lead to a deadlock.
>>
>> Does this fix it?
> If so, drivers/net/hamradio.c, function sp_get() would probably need the
> equivalent fix.  Same for drivers/net/ppp_async.c:ap_get() and sp_get() in
> drivers/net/ppp_synctty.c.
>
>    Ralf

