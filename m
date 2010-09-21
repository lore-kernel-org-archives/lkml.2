Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0IUTUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:20:43 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:54717 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0IUTUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:20:41 -0400
In-Reply-To: <alpine.LNX.2.00.1009211904290.26813@pobox.suse.cz>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>  <1283005748-3293-3-git-send-email-rydberg@euromail.se>  <B5146B49-1D7A-4AFD-B925-3F35E83A2A96@enac.fr> <alpine.LNX.2.00.1009211904290.26813@pobox.suse.cz>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <6B445E9B-2146-4AD8-B9F4-94A68E4BFA0C@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
Date: Tue, 21 Sep 2010 21:20:34 +0200
To: Jiri Kosina <jkosina@suse.cz>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 21 sept. 10 à 19:05, Jiri Kosina a écrit :

> On Tue, 21 Sep 2010, Stéphane Chatty wrote:
>
>>> The current code sometimes misses to report the last BTN_TOUCH event
>>> when multiple fingers are lifted simultaneously.  With the
>>> introduction of MT slots, the tracking id is available to determine
>>> the oldest active contact. Use this information to simplify and
>>> correct the touchscreen emulation logic.
>>>
>>
>> Acked-by: Stéphane Chatty <chatty@enac.fr>
>
> It doesn't apply without 2/3 being applied as well. So I'll not be
> applying it for now, and either please rebase it, or re-send  
> together with
> 2/3 once the situation with 0eef:72xx is sorted out. Ok?

Er, there must be some confusion here: 0eef:72xx is about hid-egalax,  
in a different thread.

Cheers,

St.

