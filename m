Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1IPRaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:30:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1IPRaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:30:07 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Greg KH" <gregkh@suse.de>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Klaus Schwarzkopf" <schwarzkopf@sensortherm.de>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de> <op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
 <20110909184354.GA30278@suse.de> <20110916171824.GA23338@linutronix.de>
Date: Fri, 16 Sep 2011 19:30:03 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v1wv8dhh3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110916171824.GA23338@linutronix.de>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 19:18:25 +0200, Sebastian Andrzej Siewior  
<bigeasy@linutronix.de> wrote:

> * Greg KH | 2011-09-09 11:43:54 [-0700]:
>
>> So we can expect more patches like this adding all of the possible
>> permutations of the different gadget devices?
>>
>> If so, ick, I thought that the work that was done was to prevent this
>> from happening, oh well :(
>
> Would it be possible to come up with a gadget-hub driver which can have
> multiple gadget attached? This should get rid of this kind of gadget
> drivers, right?

Yes, I keep thinking about such a thing for years now...

Instead of a “gadget HUB” which would have to do a lot of translation of
headers and requests, I was thinking more of making USB composite functions
even more structured (ie. adding callback for per-gadget setup,
per-configuration set-up, etc.) and then creating a composite layer which
would be feed with a trivial structure describing which functions are to
be included in which configurations.

Like I've said before, that's almost what Android does, expect it does
not support many configurations.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
