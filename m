Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0CXAgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:36:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:58295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0CXAgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BbMDBEzXwZ+U9RzR2clMTr0cWBh0mxTIc5PW4XOg564Lyeu3cxfh5hv2d7xXKP+ex3
         p3vI4BTRTPyG8BKa/UkUp7FdIzUwncWAEIn60G7d6/5bKRGyRcuoArU//bOKpMcwLyIj
         doXC9Dz59oYbIx+brHu+AACi2Nb4kUMtyXOZk=
MIME-Version: 1.0
In-Reply-To: <20100322212919.GB8941@lenovo>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.DEE.3OopLB@chimera> 
	<5712ce4f1003211947i1a2ac84ch269885f7c2888c4f@mail.gmail.com> 
	<201003222224.47780.rjw@sisk.pl> <20100322212919.GB8941@lenovo>
From: =?UTF-8?B?UkFMT1ZJQ0gsIEtyaXN0w7Nm?= <kristof.ralovich@gmail.com>
Date: Tue, 23 Mar 2010 20:35:44 -0400
Message-ID: <5712ce4f1003231735w33fb60a0h651c731fdbed747e@mail.gmail.com>
Subject: Re: [Bug #15392] The kernel does not start up.
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 17:29, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Mon, Mar 22, 2010 at 10:24:47PM +0100, Rafael J. Wysocki wrote:
>> On Monday 22 March 2010, RALOVICH, Kristóf wrote:
>> > The issue is still there with 2.6.33-rc1, 2.6.33 and 2.6.33.1 too.
>>
>> Thanks for the update.
>>
>> Rafael
>>
>>
> [...]
>
> (Out of thread)
>
> Hi Kristóf,
>
> I don't have time to take a closer look on this bug
> but curious -- what will happen if you change compressing
> method to say bz2, instead of LZMA being used now?
>
>        -- Cyrill
>

I took a look: I tested 2.6.33.1 with bz2 instead of LZMA, the same
issue is still there.

Kristof
