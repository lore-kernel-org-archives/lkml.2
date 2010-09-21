Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0IUWUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:20:39 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:58515 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0IUWUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:20:36 -0400
In-Reply-To: <4C992F2C.1070601@euromail.se>
References: <4C992775.3000000@euromail.se>  <B4B2743B-D21F-4EC2-8E1E-5C52C78B5AF6@enac.fr> <4C992F2C.1070601@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <8DAF55E8-9973-4CF4-9FD4-4E16ED9B146C@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [RESEND] hid: 3m: Adjust major / minor axes to scale
Date: Wed, 22 Sep 2010 00:20:29 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 22 sept. 10 à 00:18, Henrik Rydberg a écrit :

> On 09/21/2010 11:51 PM, Stéphane Chatty wrote:
>
>> No problem with this one at all.
>>
>> Henrik, do you confirm that this applies only to 3M? Or is it a  
>> general issue
>> with the mapping from HID to input?
>
>
> Of the devices I have seen so far, the touch width mapping is  
> fairly arbitrary.
> Some are too large, some are too small. Regarding HID drivers in  
> general, I
> really cannot say. No particular pattern so far, in other words.
>

One more device dependency, then. Grrr.

Cheers,

St.

