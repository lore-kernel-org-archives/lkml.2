Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0DZTB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:01:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47363
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab0DZTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:01:56 -0400
Date: Mon, 26 Apr 2010 12:02:00 -0700 (PDT)
Message-Id: <20100426.120200.179935218.davem@davemloft.net>
To: maciej.rutecki@gmail.com
Cc: manuel.lauss@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc5+: oops in IPv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <201004262058.24465.maciej.rutecki@gmail.com>
References: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com>
	<201004262058.24465.maciej.rutecki@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Rutecki <maciej.rutecki@gmail.com>
Date: Mon, 26 Apr 2010 20:58:24 +0200

> On niedziela, 25 kwietnia 2010 o 16:45:41 Manuel Lauss wrote:
>> 2.6.34-rc5-00204-gddc9b34  dies when sshd (openssh 5.5) is started
>> Last pull I made on April 23 was fine.
>> 
>> (transcribed from a photo):
>> 
>> BUG: unable to handle kernel NULL pointer dereference at 00000004
>> IP: [<b1535b72>] inet6_csk_bind_conflict+0x6e/0xb0
> 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=15857
> for your bug report, please add your address to the CC list in there, thanks!

It's fixed in Linus's tree like an hour after he reported this.
