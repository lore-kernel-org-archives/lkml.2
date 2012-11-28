Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2K1AwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:52:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57623 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2K1AwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <20121128081514.84c71b8eb965a7d11cb1ff07@canb.auug.org.au>
References: <20121127172548.cd502ebfb903face1dc98554@canb.auug.org.au>
	<50B5072F.6090708@infradead.org>
	<20121128081514.84c71b8eb965a7d11cb1ff07@canb.auug.org.au>
Date: Wed, 28 Nov 2012 09:52:19 +0900
X-Google-Sender-Auth: gdl6exfYAtsL5pimmB8BMiFdCTw
Message-ID: <CAH9JG2WfpNttdthgZEAM+W5T8rrZwOULSBGaSB8XdVDVMhC1FA@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 27 (media/v4l2-core/videobuf2-dma-contig.c)
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's fixed already and you will check it at Nov 28 tree
http://www.spinics.net/lists/linux-media/msg56830.html

Thank you,
Kyungmin Park

On 11/28/12, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> [Just adding some cc's]
>
> On Tue, 27 Nov 2012 10:32:15 -0800 Randy Dunlap <rdunlap@infradead.org>
> wrote:
>>
>> On 11/26/2012 10:25 PM, Stephen Rothwell wrote:
>>
>> > Hi all,
>> >
>> > Changes since 20121126:
>> >
>>
>>
>> on i386:
>>
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:743:16: error:
>> 'vb2_dc_get_dmabuf' undeclared here (not in a function)
>>
>>
>> Full randconfig file is attached.
>>
>> --
>> ~Randy
>
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
