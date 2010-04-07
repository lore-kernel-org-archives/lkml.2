Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab0DGCTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:19:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35286 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0DGCTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rzz0v+qLY6NcDdEZy9Djw84oC7lqrZkEKcCpSzwXiC4+fJazn17WsKxyfKiWuEMYsj
         wRGEYq+Oiy6F4XhTMVlJO4FV3LLPppFx0/C5u/55msRf1+HpD9uZxVOzVQejV5rd9w2U
         otPxnXHUI9j1HNzKKqCVdt6S/ujmXcYZCDv8M=
MIME-Version: 1.0
In-Reply-To: <20100407012853.GE29192@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org> <4BBBDAF4.4020304@oracle.com>
	 <20100407012853.GE29192@hexapodia.org>
Date: Tue, 6 Apr 2010 19:19:00 -0700
X-Google-Sender-Auth: 5d0b4e911226dca1
Message-ID: <o2i86802c441004061919y42d69cfft421beb7a20e0f6b6@mail.gmail.com>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset 
	failed (0xffffffff)
From: Yinghai Lu <yinghai@kernel.org>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Yinghai <yinghai.lu@oracle.com>, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 6:28 PM, Andy Isaacson <adi@hexapodia.org> wrote:
> On Tue, Apr 06, 2010 at 06:08:04PM -0700, Yinghai wrote:
>> > [    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
>> > [    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]
>> >
>> > so I've CCed a few recent committers to setup-res.c.
>>
>> can you try to boot with pci=nocrs ?
>
> That boots and configures the AHCI just fine.
>
>> also please check with -rc4.
>
> All I see in git is -rc3 + 299 commits ending with 0fdf867...
>
> That still fails with the same "controller reset failed" message from
> ahci.

please file bug and assign to Bjorn.

YH
