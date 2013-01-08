Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3AHLCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:02:05 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:44804 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3AHLCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:02:01 -0500
MIME-Version: 1.0
In-Reply-To: <50E73559.60508@wwwdotorg.org>
References: <1357316010-677-1-git-send-email-linus.walleij@stericsson.com>
	<50E73559.60508@wwwdotorg.org>
Date: Tue, 8 Jan 2013 12:02:00 +0100
Message-ID: <CACRpkdavE3g0CXc-CFgMeeY0j24N3MHWqE-0eoOwp08aU6QoJw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik: Add "ste,config" property
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 9:02 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>> -- ste,input : <0/1/2/3>
>> +- ste,config: Handle of pin configuration node (ste,config = <&in_pu>)
>> +
>> +- ste,input : <0/1/2>
>
> The changes to ste,input and ste,sleep-output look like some unrelated
> change.
>
> I guess the idea of ste,input is quite neat, but ...

I'll squash this whole thing into the patch with the device tree enablement,
so see it as a revieweing convenience that we only send the diff :-)

I'll send out a new version with all issues fixed.

Yours,
Linus Walleij
