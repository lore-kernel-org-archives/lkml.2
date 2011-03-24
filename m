Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab1CXTC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:02:56 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:46899 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933056Ab1CXTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:02:54 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: f2d_Ko4VM1m2cjotX6s3QwNAjCoItigDRMV_vH3pJfnaov8
 tC.nYxbKgJSKFmEfyhfr1Yw3Rc2S8mV51opvvL5BpavPaVIvHAhkFzP.eihI
 kIpKx1Bl3Tw3sL3i2VkxXW2nq85PKn_xfcglYYecN76q8VELD9Ju22qv1hOk
 MCpCgG6CdbDp4H5zYZvLrF1T9auumWIyiwhpqlDHAvdkwkD6AAOvMYTvk_Dw
 OkOVVCbxArr5KgcZWuz0gxe0UoRxvaTQq8zIDPiLCMLqGJBiZYl6CM8_5kJU
 1y.EDZSMruTGXWi8fpkoCC1jq8AcvIdnm.4sgN.O4V9O012y3vZ7tWHADaCI
 pvyFq1wfB5OqfhKa0KiqVtNA-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 14:02:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103241402350.5576@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger> <20110324142146.GA11682@elte.hu> <alpine.DEB.2.00.1103240940570.32226@router.home> <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com> <20110324172653.GA28507@elte.hu>
 <alpine.DEB.2.00.1103241242450.32226@router.home> <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com> <alpine.DEB.2.00.1103241300420.32226@router.home> <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com> <alpine.DEB.2.00.1103241312280.32226@router.home>
 <1300990853.3747.189.camel@edumazet-laptop> <alpine.DEB.2.00.1103241346060.32226@router.home> <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Pekka Enberg wrote:

> > Simple fix would be to do a load before the cli I guess.
>
> Btw, I tried Ingo's .config and it doesn't boot here so it's somehow
> .config related.

CONFIG_PREEMPT related?

