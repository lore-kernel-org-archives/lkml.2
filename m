Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1JUXH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 19:07:27 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:11598 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1JUXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 19:07:26 -0400
X-SpamScore: -20
X-BigFish: VS-20(zzbb2dK9371K1b0bM1432N98dKzz1202hzz8275dhz2dh87h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4EA1FB19.30001@infradead.org>
Date: Fri, 21 Oct 2011 16:07:05 -0700
From: Geoff Levand <geoff@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Christian Gmeiner <christian.gmeiner@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: Linux as Bootloader
References: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com> <4E6D2588.3010009@infradead.org> <CAH9NwWenTowswTCrrosA09D=LNF7Ej-JGNQjVxT20puA_KQ_XQ@mail.gmail.com>
In-Reply-To: <CAH9NwWenTowswTCrrosA09D=LNF7Ej-JGNQjVxT20puA_KQ_XQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On 09/16/2011 04:02 AM, Christian Gmeiner wrote:
> 2011/9/11 Geoff Levand <geoff@infradead.org>:
>> On 09/05/2011 01:24 AM, Christian Gmeiner wrote:
>>> I am using the linux kernel in combination with busybox and a separate
>>> bootloader app to
>>> startup a x86 based embedded device.
>>
>> Just FYI, Petitboot, a kexec base bootloader, does the same
>> thing as what you have done.
>>
>> I'm now working on adding a twin GUI program and an x86 OpenWRT build.
> 
> Petitboot sounds nice, but kernel.org is down. Is there an other way to get
> access to it via git?

Just FYI, my petitboot repo at kernel.org is back:

  http://git.kernel.org/?p=linux/kernel/git/geoff/petitboot.git

Also, I put a preliminary version of new Web pages I'm
working on here:

  http://bombadil.infradead.org/~geoff/petitboot/

-Geoff

  

