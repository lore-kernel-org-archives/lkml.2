Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab1JRQJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:09:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33787 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab1JRQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <m2ehyaz42p.fsf@firstfloor.org>
References: <20111018154828.GA4201@homer.localdomain>
	<m2ehyaz42p.fsf@firstfloor.org>
Date: Tue, 18 Oct 2011 12:09:10 -0400
Message-ID: <CAH3drwY34arDrp=7m-_XaQ9bFwbDgw5RoWYD9_EQS5M6ySNFEw@mail.gmail.com>
Subject: Re: IOMMU keeping mapping over long period of time
From: Jerome Glisse <j.glisse@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:56 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Jerome Glisse <j.glisse@gmail.com> writes:
>>
>> GPU for which we are interested have dma mask of 40bits at least, thus
>> they can work with high mem page. My main concern is when an iommu is
>> active, such amount of continuously mapped page might exhaust the iommu
>> address space. My understanding is that Intel & AMD iommu are capable of
>> growing their address space but is it somethings we can rely on ?
>
> I don't think relying on this is very wise. Better add some way to unmap
> when space is running short.
>
> -Andi
>

Maybe i should have add that the usecase involve the driver never knowing when
the GPU will make use of the mapped memory and this can happen anytime.

Cheers,
Jerome
