Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1GYQur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:50:47 -0400
Received: from kunder.interhost.no ([80.239.54.98]:33115 "EHLO
	kunder.interhost.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1GYQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:50:44 -0400
X-Greylist: delayed 1609 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jul 2011 12:50:44 EDT
Message-ID: <4E2D97EC.8040002@sannes.org>
Date: Mon, 25 Jul 2011 18:21:00 +0200
From: =?ISO-8859-1?Q?Asbj=F8rn_Sannes?= <ace@sannes.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110712 Thunderbird/5.0
MIME-Version: 1.0
To: morten@winkler.dk
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: Possible bug in inotify api
References: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>    <20110722160832.ee535e0c.akpm@linux-foundation.org> <d2c55b0ee77728006676dfbc07b801d8.squirrel@webmail01.one.com>
In-Reply-To: <d2c55b0ee77728006676dfbc07b801d8.squirrel@webmail01.one.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/11 07:46, Morten Winkler Jørgensen wrote:
> Hi Andrew.
>
>>> Attached: C++ program used to reproduce the behavior.
>> I ran it a couple of times on my 2.6.32-based 2-CPU desktop here and it
>> ran to completion without any complaints.
>>
>> So perhaps we fixed whatever-it-was in a later kernel.  2.6.23 is
>> pretty old!
> I see. Thank you for trying out. Once our situation allows for a kernel
> update I'll do so. In the meanwhile, I'll have to think of something else.
> Also, I'll try on other machines with newer kernels.
>
> Again, thank you for your effort
>

Actually it failed for me on 2.6.39.2

Directory D-7 deleted in /tmp.
Removes /tmp/D-7 as wd 8. Has 4994 watches
Caught: No no no...

--
Asbjørn Sannes

