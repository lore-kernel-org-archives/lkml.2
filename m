Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0ITTx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:53:26 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:48726 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0ITTxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:53:24 -0400
In-Reply-To: <4C97BAA2.6000309@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>  <1283005748-3293-2-git-send-email-rydberg@euromail.se>  <FF722ED6-6568-47D0-82D1-99B9E9D5AEAF@enac.fr> <4C97BAA2.6000309@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <9C62C97B-C427-4CC7-8248-F70DADE29A35@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
Date: Mon, 20 Sep 2010 21:53:07 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 20 sept. 10 à 21:48, Henrik Rydberg a écrit :
>>
>> I understand this as a trick to get rid of MISC/SCANCODEs that are  
>> added for
>> every EV_KEY message, consequence of a rule in hid-input.c.  
>> Wouldn't it be
>> simpler to improve the rule than to work around it?
>
>
> The main reason is to be able to set the fuzz parameters, which are  
> otherwise
> overwritten by hid-input setup.

OK, I did not notice that :-) Mmm, I guess my comment about fixing  
hid-input still holds. But we could do it in a later version if time  
is short.

St.

