Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047Ab0J1SSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:18:50 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:41505 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760923Ab0J1SSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:18:44 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xNsylvIVM1kqvrY6BMVZiTLSQlBOFUwNrRiq0eMA9r3BoSi
 xHtYJkDjhH7hRoD4FhesDXz47jga6eFEJdIwSrMG0MDlDNGfy1Bmv14JZ8QB
 mlGAOW8lzsC4v5X5nP3mGsE2TC3hDm_zwFkZEOxn.DNwzGUvE6grUFD_xz7X
 yU41PL1pRoAE2DYPlo1528XR_cH2y9tr3tRyZK2efVpTGLFhJyTgWMDkNPnh
 Wku8SedKV9Vk2T1EFhE1tSBk75GEw
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 28 Oct 2010 13:18:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mark Hounschell <markh@compro.net>
cc: Dragoslav Zaric <zaricdragoslav@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Tickles scheduler
In-Reply-To: <4CC9B2BD.1050504@compro.net>
Message-ID: <alpine.DEB.2.00.1010281317270.26782@router.home>
References: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com> <alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk> <alpine.DEB.2.00.1010271725260.9704@router.home> <AANLkTimOx=cMr+cwzEc8z7puZDEpa_7aDOxCPSzotjBP@mail.gmail.com>
 <alpine.DEB.2.00.1010280845320.25874@router.home> <4CC9B2BD.1050504@compro.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Mark Hounschell wrote:

> On 10/28/2010 09:47 AM, Christoph Lameter wrote:
> > The current plan is to switch off the tick when a process is running that
> > cannot be preempted ("realtime" (very bad choice of terms) tasks).
> >
>
> In what kind of time frame is this plan? And in the plan what will be the criteria for
> "cannot be preempted"?

Time frame is dependent on my available time unless someone else steps
forward to help out. The criteria for "cannot be preempted" could be
initially a process running with SCHED_FIFO.
