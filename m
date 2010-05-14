Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab0ENTED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:04:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61389 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195Ab0ENTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=DonGvkAN0BUVq9JlrkQn7hTx0OgsRp5/xffI0QRDupBLUK5GJo7acBhmNXgsy3F80L
         FMbX/07w5RTi65UqUNB8fXdeZR2RJuBDcEFmLTu2QgTs+HrILAwxKzuMvrnRSAfGHRMS
         A4BL+BG/JKyCstXgNVRRxcDvWk4aAAv2inrGc=
References: <4BEC7A84.3010503@gmail.com> <201005141520.30802.br1@einfach.org> <4BECEE3E.6090303@gmail.com> <201005141538.43416.br1@einfach.org> <4BED6F19.3040608@gmail.com> <20100514165325.GA28198@tux> <4BED8765.8040307@gmail.com> <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com>
Message-Id: <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Date: Fri, 14 May 2010 12:04:15 -0700
Cc: Bruno Randolf <br1@einfach.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On May 14, 2010, at 10:29 AM, "Luis R. Rodriguez" <lrodriguez@atheros.com 
 > wrote:

> On Fri, May 14, 2010 at 10:24 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>
>>
>> here you go:
>> (I was grabbing the info
>> after rmmod and modprobe)
>>
>> [    7.034242] ATH9K: cachelsz: 256
>> [   69.175348] ATH9K: cachelsz: 256
>
> Close, so I without any patches applied, and by just running  
> modprobe as below:
>
>
> modprobe ath9k debug=0x00000200
>
>               ath_print(common, ATH_DBG_CONFIG, "cachelsz %u  
> rxbufsize %u\n",
>                               common->cachelsz, common->rx_bufsize);
>
>
> This is already in the code so just please do this:
>
> rmmod ath9k
> modprobe ath9k debug=0x00000200
> dmesg | grep cachelsz

O.k. I did a git reset to the origin
Then the above, unfortunantly nothing
Shows up when grepping
Any CONFIG options I might be missing?

Justin P. Mattock
