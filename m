Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2KWJop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:44:45 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49374 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2KWJoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:44:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121123094044.GF17471@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<20121122102710.GD4328@gmail.com>
	<CAKohpo=gctcd5+bZ8xeJn-Cx3=+=+uxaCzEoZhFmp+XaJSpf9Q@mail.gmail.com>
	<20121123094044.GF17471@gmail.com>
Date: Fri, 23 Nov 2012 15:14:43 +0530
Message-ID: <CAKohpo=i0M6tg2z-+MBZYi57pdAf4rMnevdNoW3ctKndNCHA1g@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] mfd: stmpe: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 15:10, Lee Jones <lee.jones@linaro.org> wrote:
> That's not how it works.
>
> Apply my Acked-by yourself and re-send the patch-set as a whole.

I don't thinks so. This patch is not doing anything with DT stuff and so
can be applied separately. Related patches should be posted together
though.

--
viresh
