Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2KHVXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:23:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab2KHVXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:23:05 -0500
Message-ID: <509C22B2.8010600@redhat.com>
Date: Thu, 08 Nov 2012 13:22:58 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120825 Thunderbird/10.0.7
MIME-Version: 1.0
To: nab@risingtidesystems.com
CC: Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>
Subject: Re: scsi target, likely GPL violation
References: <509A915B.30105@redhat.com>  <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>  <509B117A.6070708@genband.com>  <509BE460.6010404@redhat.com> <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 12:05 PM, Nicholas A. Bellinger wrote:
> Accusing us of violating GPL is a serious legal claim.  
> 
> In fact, we are not violating GPL.  In short, this is because we wrote
> the code you are referring to (the SCSI target core in our commercial
> RTS OS product), we have exclusive copyright ownership of it, and this
> code contains no GPL code from the community.  GPL obligations only
> apply downstream to licensees, and not to the author of the code.  Those
> who use the code under GPL are subject to its conditions; we are not.

Hi Nick, thanks for finally responding.

I believe your argument is wrong for two reasons.

First, LIO is a derivative work of the Linux kernel. It uses kernel APIs
and headers. You ship Linux as part of RTS OS. Even if you had not asked
for LIO to be included in mainline, this would still be true and would
require you to publish your changes under the GPLv2.

Second, you claim you hold exclusive copyright for the code. Not true.
One example: on http://www.risingtidesystems.com/storage.html you claim
support for FCoE. You didn't build tcm_fc, Intel did. Under the GPLv2.
Furthermore, SRP support came from SCST, iirc. None of these
contributors gave RTS any right to use their copyrighted code except
under the conditions of the GPLv2.

> As you know, we contributed the Linux SCSI target core, including the
> relevant interfaces, to the Linux kernel.  To be clear, we wrote that
> code entirely ourselves, so we have the right to use it as we please.
> The version we use in RTS OS is a different, proprietary version, which
> we also wrote ourselves.  However, the fact that we contributed a
> version of the code to the Linux kernel does not require us to provide
> our proprietary version to anyone.

In addition to the two reasons above, how does it make any sense that
you are spending time maintaining in-tree LIO when none of that code can
theoretically benefit RTS's proprietary product? The more likely
scenario is you are basing your product on mainline LIO.

> If you want to understand better how dual licensing works, perhaps we
> can talk off list.  But we don’t really have a responsibility to respond
> to untrue accusations, nor to explain GPL, nor discuss our proprietary
> code.

All the contributions and improvements (there have been a LOT) since LIO
entered mainline are GPLed by their authors. If you incorporated any of
those improvements or fixes into RTS OS, then there's a third reason why
your code is subject to the GPL.

> We’re very disappointed that Red Hat would not be more professional in
> its communications about licensing compliance matters, particularly to a
> company like ours that has been a major contributor to Linux and
> therefore also to Red Hat’s own products.  So, while I invite you to
> talk about this with us directly, I also advise you – respectfully – not
> to make public accusations that are not true.  That is harmful to our
> reputation – and candidly, it doesn’t reflect well on you or your
> company.

I tried the private route but you and your CEO stalled, and then stopped
talking to me.

Please just start behaving properly w/r/t the GPL so we can all get back
to coding.

Regards -- Andy
