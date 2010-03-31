Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab0CaUPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:15:07 -0400
Received: from 55.58.140-88.rev.gaoland.net ([88.140.58.55]:39867 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757954Ab0CaUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:15:05 -0400
Date: Wed, 31 Mar 2010 22:14:26 +0200
From: =?unknown-8bit?B?RnJhbsOnb2lz?= Romieu <romieu@fr.zoreil.com>
To: Neil Horman <nhorman@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100331201426.GA3228@electric-eye.fr.zoreil.com>
References: <20100331102142.GA3294@swordfish.minsk.epam.com>
 <20100331111942.GB13963@hmsreliant.think-freely.org>
 <20100331121426.GB3294@swordfish.minsk.epam.com>
 <1270038569.2103.24.camel@edumazet-laptop>
 <20100331133533.GD13963@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331133533.GD13963@hmsreliant.think-freely.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@redhat.com> :
[...]
> +1 I wouldn't be suprised if using something over the nominal 1522 byte frame
> length on r8169 caused tx errors.  The driver doesn't seem to support Jumbo
> frames, so my guess is you have to keep the packet size below 1522 bytes.

-1

The driver does not support Jumbo frames because the original 8169 will not
go much beyond 7200 (see r8169.c::SafeMtu and netdev circa 2004 december 7).

/me checks... Apparently it still works a bit.

Sergey, can you 'dmesg | grep XID' and send the output of a lspci as
well as the MTU used during the test ?

-- 
Ueimor
