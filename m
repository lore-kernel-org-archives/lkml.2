Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0IEL7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 07:59:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0IEL7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 07:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CxK++dBMxcBk25aBCByOkd3tcPYZbT0bk2oKgQn0oMEKTZpmLPYW/9HL1OWzsToWJv
         u80AEwUnZ3h04pG5PcSnUZkv+V+Tt2/N4l+S8YuBBf2SH3bLwwR+RK4dWPQ80D9hosHY
         wV2t/fNQ7eilRX5mgU8fCLa7DVDx+Q4XayISY=
MIME-Version: 1.0
In-Reply-To: <20100905112152.GA558@n2100.arm.linux.org.uk>
References: <20100819174426O.fujita.tomonori@lab.ntt.co.jp>
 <m3sk1yzkjw.fsf@intrepid.localdomain> <20100901085738.GJ8142@n2100.arm.linux.org.uk>
 <20100902114937X.fujita.tomonori@lab.ntt.co.jp> <20100902055907.GA3287@riccoc20.at.omicron.at>
 <AANLkTi=TfmFPSfw3iYUMzxdsCLC7keJxMbb7vZvQHoiO@mail.gmail.com> <20100905112152.GA558@n2100.arm.linux.org.uk>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 5 Sep 2010 19:58:39 +0800
Message-ID: <AANLkTi=K_nV+xOCD4tGT3Df74EWq2crjpkLyXtOkHsC9@mail.gmail.com>
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce devices
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Cochran <richardcochran@gmail.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, khc@pm.waw.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 5, 2010 at 7:21 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Sep 05, 2010 at 06:50:17PM +0800, Eric Miao wrote:
>> On Thu, Sep 2, 2010 at 1:59 PM, Richard Cochran
>> <richardcochran@gmail.com> wrote:
>> > On Thu, Sep 02, 2010 at 11:50:33AM +0900, FUJITA Tomonori wrote:
>> >> btw, I can't compile ARCH_IXP4XX without the following patch:
>> >>
>> >> http://www.spinics.net/lists/arm-kernel/msg95933.html
>> >
>> > I have the same problem. Compilation of IXP4xx was broken by
>> >
>> >    commit 4fa5518c65df7a2c4b6c58061ac53d0b01228042
>> >    Author: Eric Miao <eric.y.miao@gmail.com>
>> >    Date:   Sat Jun 5 15:16:17 2010 +0800
>> >
>> >    [ARM] pxa: remove now unnecessary dma_needs_bounce()
>> >
>> > What is the correct way to do fix this? Is the above patch the
>> > solution, or is dma_needs_bounce() perhaps also unnecessary for ixp?
>> >
>>
>> My bad to break this. If there is no quick proper fix, I'd prefer this
>> being reverted first.
>
> Reverted.
>
> Can I assume that I can commit this with:
>
> Reported-by: Richard Cochran <richardcochran@gmail.com>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>

Yes please.
