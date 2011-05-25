Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1EYUn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:43:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:38428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1EYUn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:43:27 -0400
Message-ID: <4DDD6A2D.7050506@suse.cz>
Date: Wed, 25 May 2011 22:44:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaud Giersch <arnaud.giersch@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/34] parport: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>	<1302015561-21047-21-git-send-email-mmarek@suse.cz> <wwetyeclb8x.fsf@powwow.iut-bm.univ-fcomte.fr>
In-Reply-To: <wwetyeclb8x.fsf@powwow.iut-bm.univ-fcomte.fr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.4.2011 22:00, Arnaud Giersch napsal(a):
> Mardi 05 avril 2011, vers 16:59:07 (+0200), Michal Marek a écrit :
> 
>> The kernel already prints its build timestamp during boot, no need to
>> repeat it in random drivers and produce different object files each
>> time.
>>
>> Cc: Arnaud Giersch <arnaud.giersch@free.fr>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>>  drivers/parport/parport_ip32.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> I do not use this module anymore, but anyway...
> 
> Acked-by: Arnaud Giersch <arnaud.giersch@free.fr>

Applied to kbuild-2.6.git#trivial

Michal
