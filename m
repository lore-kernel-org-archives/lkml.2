Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1CPR0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:26:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48099 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1CPR0C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w+ePLqH57RBZXUtqgIqRLEd8dOLB5kMv5c2hiawXj6sMBa13sVW/wRpxQQKgtMU6TN
         HG1TPhYoPlgl0JRUwCsW7IY91YXntLhJQ+VMl02EeCeghBvJLQ/WCRsa23kRCosFNUU2
         Ko/lBjtiSgCPWRF0nyc581KYsXufyBwAkYwtE=
MIME-Version: 1.0
In-Reply-To: <354760CEA71F254DBD117DC5DF6B46227C5EACA4D7@GVW1118EXC.americas.hpqcorp.net>
References: <354760CEA71F254DBD117DC5DF6B46227C5EACA3BE@GVW1118EXC.americas.hpqcorp.net>
	<20110316140237.GA18392@kroah.com>
	<354760CEA71F254DBD117DC5DF6B46227C5EACA4D7@GVW1118EXC.americas.hpqcorp.net>
Date: Wed, 16 Mar 2011 20:24:04 +0300
Message-ID: <AANLkTimvQsmi56vpeX3e8fMmkNYHy9k6=A9vDz5cicyP@mail.gmail.com>
Subject: Re: FW: smart card driver (ricoh) with ubuntu
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Garcia, Alfredo (Sales)" <alfredo.garcia-sanchez@hp.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 March 2011 17:22, Garcia, Alfredo (Sales)
<alfredo.garcia-sanchez@hp.com> wrote:
> Hi to all!
>
> I'm Alfredo Garcia,  Bussines Developer in HP Spain.
>
> I,m searching a linux expert.
>
> I have a problem in ubuntu linux because I don't have the driver smartcard (ricoh) Ricoh Co Ltd RL5c476 II (don't exist the driver). We changes the smart card device in all new laptops and ricoh don't have the linux driver for the smart card. The smart card in integrated in the mother board.
>
> Is difficult develop a driver?? Could you make it?
> Can you help me?

RL5c476 II is flash card reader chip, not smart card. It seems modern
linux should support it.
