Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1EESUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:20:23 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:33504 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755696Ab1EESUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:20:22 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 10nIlsoVM1k6PivL.CslAk_aFsfVkOvPXsWUeK8UK8JIz0B
 DVDui.ZkbNwL3peYwej5yDJTKBke2wHJfGUJW5hyqQ.F2iMLI.84osVbFEAP
 AFz57I57voab0Gpl67O8j0aTtnlY__sT__fW0OvcQ5e0HBLaFkCNYs4Is9AO
 h2ZXip6k5rtbklo5PdRiwYvNE0pq25Wu8r2LGIkwRzKyeniJjt1I7WNd.H3x
 EjlxiavMlE6YRgVbZZh13Y7jvZR3sRejKFVXA.MftXIwEV3QBmWRPapGzPyO
 rRbiYljQXKLwYsS2_zbeit6x3fooVcPjQasW5YRN0jL31kKYgEHiHelQbXle
 NbUSrhxz.8di_F5q6XeF2EQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 5 May 2011 13:20:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110505095421.GD30950@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1105051319230.6821@router.home>
References: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com> <alpine.DEB.2.00.1105041454190.5495@router.home> <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com> <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com> <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Tejun Heo wrote:

> Anyways, that's what I've been thinking.  I'll get to it in the next
> devel cycle or the one after that.  What do you guys think about soft
> irq masking idea?

Great idea. Would make the whole irq on/off business much cheaper.

