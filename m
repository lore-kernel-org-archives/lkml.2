Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1FNOEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:04:07 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32579 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750864Ab1FNOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:04:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: WnJZFbwVM1lHy5cE0Ix_5Hvb5lV8beo0Y9S1AMX_6SvAAMA
 RksWcxRf3Z7VSSWHV5zw6TVJhNoP93yFJ9yiXtKtA60Qep6UOR4sGJ6OdsYg
 .38wY59li5i2YoIjUUr3IncmNeyvIdQG.R4uiVHItdB7lkIJs.wQXIPc9l9w
 VUKRd_yLt4G5MyoDY.3SWs8L6fFwkQ6jnnapvNrPCYvQL_w0DKI2pxoLZW4l
 HTP.tmcwbfw1r.Xug3olAUA1tWfjhMdkBnAx5E9PdnGEE6axMC2hl7yhym4u
 Db40e4Sk1QSizCPAvxoZc8UwHIeqqOKfKA6owq_0VHfm6EB6U96GPejSOvlL
 ahSB5vzdwjcddyVgK4F4qVGMa
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Jun 2011 09:04:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
In-Reply-To: <20110614080436.GB29900@elte.hu>
Message-ID: <alpine.DEB.2.00.1106140903480.32130@router.home>
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <4DF09827.7070809@cs.helsinki.fi> <alpine.DEB.2.00.1106101016420.30968@router.home> <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com> <alpine.DEB.2.00.1106111202110.32170@router.home>
 <4DF6F659.3000109@cs.helsinki.fi> <20110614080436.GB29900@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Ingo Molnar wrote:

>
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
> > On 6/11/11 8:02 PM, Christoph Lameter wrote:
> > >On Sat, 11 Jun 2011, Pekka Enberg wrote:
> > >
> > >>Oh, I don't know - but I definitely need more ACKs to even consider
> > >>pushing this through slab.git.
> > >
> > >Any additional ackers out there?;-)
> >
> > Ingo, ping? Could we have this in -tip so I can pull from there?
> > This is blocking me from queuing SLUB performance improvements to
> > linux-next.
>
> hpa, what's your take on this patch?

He acked it.

