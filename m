Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2FLHJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:09:02 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:1268 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2FLHJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:09:00 -0400
Message-ID: <4FD6EA5B.5030905@spin.net.au>
Date: Tue, 12 Jun 2012 17:06:03 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120422 Firefox/12.0 SeaMonkey/2.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: gcc compiler modification to cater for new programming language
References: <4FD40035.2020200@spin.net.au> <CAM_iQpXyMhx5JszEew1O9ehQ0z-eOCZ_DjpdFPNJuKfVafcL3g@mail.gmail.com>
In-Reply-To: <CAM_iQpXyMhx5JszEew1O9ehQ0z-eOCZ_DjpdFPNJuKfVafcL3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.14, required 4, AWL 0.36, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang wrote:
> On Sun, Jun 10, 2012 at 10:02 AM, Chris Jones<chrisjones@spin.net.au>  wrote:
>> Is it possible to modify the source code of gcc to enable to compilation of
>> a completely new programming language, as yet unrecognized? How much of a
>> big job would I be looking at for such a task?
> Yeah, you need to write a gcc front-end for it.
>
>

Why would you suggest writing a front-end for it? I think you're wrong 
there as a front-end has nothing to do with the functionality of gcc. 
Explain to me why you would suggest this? Curious.

I am aware it is off-topic and have also brought it up on the gcc 
mailing list, thanks.


Regards

-- 
		Chris Jones

OpenSUSE Linux x86_64 (PC)|Android (Smartphone)|Windows x86 (Gaming!)
Kernel developer|Lead Developer of SDL|Lead Developer of Nest Linux|Gamer and Emulator nut|Web Services|Digital Imaging Services
Controllers: Rapier V2 Gaming mouse|Logitech Precision|PS3 controller|XB360 controller|Logitech Attack 3 j/stick
Emulators: Fusion|Gens|ZSNES|Project64|PCSX-R|Stella|WinVICE|WinUAE

