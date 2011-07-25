Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1GYSSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:18:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1GYSSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:18:40 -0400
Message-ID: <4E2DB359.5060208@redhat.com>
Date: Mon, 25 Jul 2011 14:18:01 -0400
From: Eric Paris <eparis@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: morten@winkler.dk
CC: =?ISO-8859-1?Q?Asbj=F8rn_Sannes?= <ace@sannes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Possible bug in inotify api
References: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>    <20110722160832.ee535e0c.akpm@linux-foundation.org>    <d2c55b0ee77728006676dfbc07b801d8.squirrel@webmail01.one.com>    <4E2D97EC.8040002@sannes.org> <1ef7327eb07f3de0a776e22f724f92fc.squirrel@webmail01.one.com>
In-Reply-To: <1ef7327eb07f3de0a776e22f724f92fc.squirrel@webmail01.one.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 02:17 PM, Morten Winkler Jørgensen wrote:
>>>> So perhaps we fixed whatever-it-was in a later kernel.  2.6.23 is
>>>> pretty old!
>>
>> Actually it failed for me on 2.6.39.2
>>
>> Directory D-7 deleted in /tmp.
>> Removes /tmp/D-7 as wd 8. Has 4994 watches
>> Caught: No no no...
> 
> Ah. My colleague also saw this on an installation of the latest stable 
> OpenSuSE, featuring a 2.6.37.6 kernel.
> 
> I've never attended this mailinglist before. Is there anything I should to
> to assist the investigation? Or just be patient?

Be patient.  I'm running a bit behind....

-Eric
