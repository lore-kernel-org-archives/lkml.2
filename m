Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2CZGzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:55:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58850 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2CZGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <F45880696056844FA6A73F415B568C6958BEEDDB7F@EXDCVYMBSTM006.EQ1STM.local>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
	<20120320153912.b97107ca4128d0692de17799@canb.auug.org.au>
	<20120326131316.b791ebefd94d8cbcac5bccfa@canb.auug.org.au>
	<F45880696056844FA6A73F415B568C6958BEEDDB7F@EXDCVYMBSTM006.EQ1STM.local>
Date: Mon, 26 Mar 2012 08:55:37 +0200
Message-ID: <CACRpkdY2SrRNhQKTH1V_MJ2ZoLMnOD8-=Qfzc3XeXBHZk-dUUg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the battery tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 4:31 AM, Arun MURTHY <arun.murthy@stericsson.com> wrote:

> There is a dependency with MFD tree. Please pull the MFD tree along with
> these patches to overcome the build errors.

Maybe the problem is that the needed MFD changes have not reached
the MFD for-next branch? (To me that looks like the actual issue.)
I think Anton pulled these in to some branch to test it and had it working
fine so some cross-dependency issue...

Yours,
Linus Walleij
