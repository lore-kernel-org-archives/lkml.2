Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2IDRf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:35:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52865 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2IDRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120904133650.2cf50515@endymion.delvare>
References: <20120723173415.5b80b28b@endymion.delvare>
	<20120801111359.6839bec7@endymion.delvare>
	<20120801101646.GG16859@sortiz-mobl>
	<20120904133650.2cf50515@endymion.delvare>
Date: Tue, 4 Sep 2012 19:35:55 +0200
Message-ID: <CACRpkdaduGTjz6F84ETrwjUyf=o7LsG_g9LMRUiRc3n+Mf60-Q@mail.gmail.com>
Subject: Re: [PATCH] gpio-ich: Share ownership of GPIO groups
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 1:36 PM, Jean Delvare <khali@linux-fr.org> wrote:

> Any news on this? I'd like to get this patch (or an alternative
> implementation of the same) into kernel 3.7, and its merge window is
> approaching.

I have acked the GPIO part, the rest is up to Sam. He's often in
submarine mode but usually he appears just in due time for the merge
window...

Yours,
Linus Walleij
