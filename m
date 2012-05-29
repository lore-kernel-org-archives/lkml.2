Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2E2QwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:52:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39085 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753984Ab2E2Qv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:51:59 -0400
Message-ID: <1338310317.18199.6.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Date: Tue, 29 May 2012 09:51:57 -0700
In-Reply-To: <CAPXgP11G17ty8rCB8qhJtXCVpbvzdoT-VT_p2c4i3jMrkGDRYw@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
	 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
	 <1338307620.886.21.camel@mop> <1338308088.2202.39.camel@joe2Laptop>
	 <CAPXgP11G17ty8rCB8qhJtXCVpbvzdoT-VT_p2c4i3jMrkGDRYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 18:34 +0200, Kay Sievers wrote:
> The damn !CONFIG_PRINTK case. :) Fixed!

Maybe more appropriate is a ;)  Thanks.

When you get a chance, could you comment on the
RFC patch to convert the <.> in KERN_<LEVEL>
to an ascii SOH.

https://lkml.org/lkml/2012/5/24/350

It doesn't / shouldn't affect any output anywhere
as vprintk_emit converts it back to <.> for the
actual output, it saves some space, and it makes
KERN_CONT/pr_cont unnecessary as anything other
than a notational marker.

