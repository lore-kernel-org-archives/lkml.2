Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1FJPRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:17:19 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:30037 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757538Ab1FJPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:17:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Jp2C50IVM1mUEm87U2TYbObAYH.DVqXWlH4nNC05a26XC0x
 OnrsAJhuZDDXXH_AOu_CUSaw4TLYpOJNCj_WgZxcwoPhe_ByBfXGAcLkVEy1
 4myMmW5XqEYDcz.1SswVcDM3zAvbXPvjS2qMM7uCLvjxjBqvqblCtpj7AgLw
 R5dtBkBCPaCczBKxfHXNJF5nQN89Fjsd5UThqYlfVeV_M.jbf8w.NN2yFH21
 4i4vzx1ltABmKMz0npx1uj_29DOEfr0O4.xc.5XAdWZCGB9Y2fr3HzZ_rPO9
 mST6v4BFFpkS0VS7xQHGRuAAqBb2r4N5xSDN4O47j2_cuYscVO.aJfgJuOWq
 BIOUmUSWfxJFJjAs5m3J1fA0K
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 10 Jun 2011 10:17:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
In-Reply-To: <4DF09827.7070809@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1106101016420.30968@router.home>
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <4DF09827.7070809@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Pekka Enberg wrote:

> Tejun, I'm going to queue this series for linux-next in the next few days.
> Could you either pick up this patch so I can pull from your tree or
> alternatively, is it OK to queue this through slab.git?

This patch is not related to percpu functionality. Tejun does general x86
patches?

