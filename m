Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2GQQr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab2GQQrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:47:24 -0400
Message-ID: <50059713.7090606@redhat.com>
Date: Tue, 17 Jul 2012 18:47:15 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com> <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com> <50044D56.6000400@redhat.com> <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com> <50052390.7030908@redhat.com> <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com> <5005285E.8060706@redhat.com> <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com> <20120717163612.GA15995@infradead.org>
In-Reply-To: <20120717163612.GA15995@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 18:36, Christoph Hellwig ha scritto:
>> > There's no such thing in the market today as a removable disk that's
>> > resizeable.  Removable disks are for things like backup cartridges and
>> > ageing jazz drives.  Worse: most removeable devices today are USB card
>> > readers whose standards compliance varies from iffy to non existent.
>> > Resizeable disks are currently the province of storage arrays.
> The virtual disks exported by aacraid are both marked removable and
> can be resized.

Do they report resizing via unit attention?  I can skip this part on
removable virtio-scsi disks if that's what real hardware does, it would
also work.

Paolo


