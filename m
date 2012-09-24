Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab2IXT5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:57:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58158 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2IXT5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120924181025.GG7694@google.com>
References: <20120921192720.GJ7264@google.com>
	<CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
	<CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
	<5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
	<CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
	<5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
	<CAHCeSFp2=CzO1-dw_Ym_s4Pn04nsC_kQUerFJ+uFLh8iinX+Ug@mail.gmail.com>
	<CAK-9PRB7KvPNgcsXiNG08-7OdrkkNc2ushusXh9rVm93J0xcHA@mail.gmail.com>
	<CAHCeSFqmeOkKySxMUXgtnev+HL-NC6MdmeuDYONymYaNczb7RA@mail.gmail.com>
	<CAHCeSFq31fQuZd+Phgx-dQ1AEeDTh268WH14bDqEKqneOLpqxQ@mail.gmail.com>
	<20120924181025.GG7694@google.com>
Date: Mon, 24 Sep 2012 20:57:40 +0100
Message-ID: <CAHCeSFr4stF6BNGL7=7oPYzKqOZ-Ya8VUD02rjFRq1thMULFXw@mail.gmail.com>
Subject: Re: Work queue questions
From: Deepawali Verma <dverma249@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Chinmay V S <cvs268@gmail.com>, Daniel Taylor <Daniel.Taylor@wdc.com>,
        anish singh <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

May be I misunderstood, I read in the documentation about max_active.
In this case, max_active is 1, but I created three workqueues, do you
mean to say for this case, single thread can process three requests
queued up in the three different workqueues.

Sorry, if I misunderstood.

Regards,
Deepa



On Mon, Sep 24, 2012 at 7:10 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Sep 24, 2012 at 05:56:10PM +0100, Deepawali Verma wrote:
>> Hi,
>>
>> This is sample code snippet as I cannot post my project code. In
>> reality here, this work handler is copying the big chunks of data that
>> code is
>>  here in my driver. This is running on quad core cortex A9 Thats why I
>> asked. If there are 4 cpu cores, then there must be parallelism. Now
>> Tajun, what do you say?
>
> My name is Tejun and please lose the frigging attitude when you're
> asking things.
>
>> >>> alloc_workqueue(obj[i].my_obj_wq_name,WQ_UNBOUND,1);
>
> Especially if you're not properly reading any of the documentation,
> function comment and my explicit response mentioning @max_active. :(
>
> --
> tejun
