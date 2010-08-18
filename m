Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0HRQhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:37:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:58108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0HRQg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:36:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Zyij4oquIrFtjYGpgvBLzzU3H5Uilkh/0gp1R0OSA7NuwXtnE4Lozs/BHExXD030o
	vEi6RTsi9KCVxRrOWphxg==
MIME-Version: 1.0
In-Reply-To: <20100818153016.GA6235@infradead.org>
References: <AANLkTinx-cgn7zony8UO__zejj36GxcJTf3Pr2Z9G2af@mail.gmail.com>
	<201008181704.51357.arnd@arndb.de>
	<20100818153016.GA6235@infradead.org>
Date: Wed, 18 Aug 2010 09:36:53 -0700
Message-ID: <AANLkTin8iYD-mfUDqXaBLyRmbBZax98+NLF5TGAKrX+s@mail.gmail.com>
Subject: Re: [PATCH] V2 2.6.35 libata support for > 512 byte sectors (e.g. 4K Native)
From: Grant Grundler <grundler@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jeff Garzik <jgarzik@pobox.com>,
        Tejun Heo <tj@kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 8:30 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Aug 18, 2010 at 05:04:51PM +0200, Arnd Bergmann wrote:
>> On Tuesday 17 August 2010, Grant Grundler wrote:
>> > [ patch NOT inlined because gmail will word-wrap and make a mess of
>> > it. Please use attached file.]
>>
>> You should be able to use git-send-email with a gmail account to fix this.

I'll try git-send-email next time - thanks Arndt.

> Or find an google insider that could fix gmail..

You have no idea how many people have already tried this. Just feels
like another windmill at this point. :)

thanks,
grant


>
>
