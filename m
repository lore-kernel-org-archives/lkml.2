Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1HYOHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:07:22 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:29375 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751764Ab1HYOHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:07:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8AC7O5oVM1lxN_Ss_mCU4teYfK9bCbiFVqd4vNo9eJKBTMm
 7kHTeu8wpPHUFZYffkiH4yZNFhAVhSDzGL3f60PVU9NDmPQiXMYdS_QON213
 Xt1DLu7ckXR4nuqX3vgtPEjaJD8UMtWSNLtGYF8FR_pQpgia0g7F1WXfTtOU
 A0taGtce0rq1BXaTPr9RonnS8ENcTH6oKaHCTH8RKHBfbKmvjymKXkPHZmQg
 4oisRCBUPWuDj5K5zhCHkUw8seMf94lK0QURvZdg6nmWXsbT6M.G2.I7GMyl
 DidFEg5ZcsmMZqR90TraxReA9SClUKHURu504Ulrc_Hx9CjrowMcqUOmUj9m
 m3U65hXQcsan9EjmfqsyziKJO_AWzZ32x1SWmblhZhAAhLg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 09:07:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
In-Reply-To: <4E5586FD.7080103@goop.org>
Message-ID: <alpine.DEB.2.00.1108250906020.27407@router.home>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com>
 <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home> <4E5527C2.8000801@goop.org> <alpine.DEB.2.00.1108241408310.30776@router.home> <4E555FBB.3020906@zytor.com> <4E556150.8030100@goop.org> <4E558380.7060304@zytor.com>
 <CA+55aFy9r7jHi_9B4zH9LEy4PidWvjs5nDddHA5RyKRvunDehA@mail.gmail.com> <4E5586FD.7080103@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Jeremy Fitzhardinge wrote:

> But the interface hides the implementation specifics, so its not all
> that important.

Ok but could you make it consistent throughout? The cmpxchg_double's do
not have the _flags at the end but also already do a sete. So either
rename those or come up with another convention?

