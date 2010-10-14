Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0JNMSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:18:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60276 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0JNMSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RzFB604jgK6wK7Ne8+FXY+1iy5fbvRKIM2EZo1EE7Z4JImtJTrlBlOgy2SOFKZiPT+
         P8BGIv2nn1EQnjKOa7JWpCERaUoEvDTgkZbeRXtxRLdmccG+5iFMtsAlLId8WDAbDf5V
         Q0Fu8I7wrkUX/SdYo+x1w+xfVirXjCB9Qr4hs=
MIME-Version: 1.0
In-Reply-To: <20101014072421.GA13414@basil.fritz.box>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<87sk0a1sq0.fsf@basil.nowhere.org>
	<20101014160217N.fujita.tomonori@lab.ntt.co.jp>
	<20101014072421.GA13414@basil.fritz.box>
Date: Thu, 14 Oct 2010 15:10:07 +0300
Message-ID: <AANLkTi=mGPjL0T33cuYbpKyc=a3d9XTCJqwBLFqVmWpm@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:24 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Oct 14, 2010 at 04:07:12PM +0900, FUJITA Tomonori wrote:
>> On Wed, 13 Oct 2010 09:01:43 +0200
>> Andi Kleen <andi@firstfloor.org> wrote:
>>
>> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>> > >
>> > > What this wants to do:
>> > >   allocates a contiguous chunk of pages larger than MAX_ORDER.
>> > >   for device drivers (camera? etc..)
>> >
>> > I think to really move forward you need a concrete use case
>> > actually implemented in tree.
>>
>> As already pointed out, some embeded drivers need physcailly
>> contignous memory. Currenlty, they use hacky tricks (e.g. playing with
>> the boot memory allocators). There are several proposals for this like
>
> Are any of those in mainline?

drivers/video/omap/

-- 
Felipe Contreras
