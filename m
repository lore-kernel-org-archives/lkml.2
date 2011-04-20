Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1DTQvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:51:07 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:33149 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752525Ab1DTQvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:51:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hkAI3.8VM1lVellw8h0zWrDKl9jwq2DR.225wqhXuX0ijCQ
 zKFNXWXWWa.03vB7MN618SdgwF7hsezOwEoDjxa4mq8q7QkdFVZ.Gbb3jC6a
 PxOY_gdjcRkJG4GgiSFiz_qidzPQ1kQ9BXkhHZBO9HjoCsRGJ1exCMIVH5NE
 TH42gLKcich_G3HfiG_BLqoJ24BbaYXop0zetXVgvtRjc_y0lqCL..AFfvpE
 fVfjOVWLG7W02cWVTEs3EZwu.g7GFIhBH.5v70Gp5Z8KGWwOQKICPqVLEtCu
 8MAR3LBfOdknArw_KI651lJsyuUI6.em2GAP7Q7fxYs9Sc9ea
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Apr 2011 11:50:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303317178.2587.30.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104201149520.12154@router.home>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com>  <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>  <20110420174027.4631.A69D9226@jp.fujitsu.com> <1303317178.2587.30.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, James Bottomley wrote:

> > > That part makes me think the best option is to make parisc do
> > > CONFIG_NUMA as well regardless of the historical intent was.

Well if it never supported NUMA then this is going to be problematic.
> > >
> > >                         Pekka
> >
> > This?
>
> I'm afraid it doesn't boot (it's another slub crash):

Is there any simulator available that we can use to run a parisc boot?

