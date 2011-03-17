Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1CQAfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:35:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab1CQAfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
References: <20110316210300.GA3311@kroah.com> <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
 <20110317002818.GA19812@kroah.com> <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 17:34:08 -0700
Message-ID: <AANLkTinznDAXuxv8AU=tZpTq81f_S8vTyAqRMm=nfAKS@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING patches for .39
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 5:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The one with inifinite errors was vt6655.

vt6656 had same/similar issues. In fact, maybe it's simply because I
built both of them in, and get infinite "multiple definitions" because
they are the same driver with small differences?

                       Linus
