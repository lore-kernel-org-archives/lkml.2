Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3AFWOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:14:30 -0500
Received: from jdl.com ([208.123.74.7]:33449 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3AFWO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:14:27 -0500
X-Greylist: delayed 2303 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2013 17:14:27 EST
Message-Id: <E1TryU3-0001K5-Iy@jdl.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
cc: David Gibson <david@gibson.dropbear.id.au>, Matt Porter <mporter@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: Fix test relying in wrong behavior of is_printable
In-reply-to: <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com>
References: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com> <20130106035809.GG4674@truffula.fritz.box> <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com>
Comments: In-reply-to Pantelis Antoniou <panto@antoniou-consulting.com>
   message dated "Sun, 06 Jan 2013 13:41:56 +0200."
Date: Sun, 06 Jan 2013 16:14:23 -0600
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi David
> 
> =CE=91=CF=80=CF=8C =CF=84=CE=BF iPhone =CE=BC=CE=BF=CF=85
> 
> 6 =CE=99=CE=B1=CE=BD 2013, 5:58, =CE=BF/=CE=B7 David Gibson <david@gibson.dr=
> opbear.id.au> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
> 
> > On Fri, Jan 04, 2013 at 09:16:08PM +0200, Pantelis Antoniou wrote:
> >> After fixing the is_printable bug the test suite fails.
> >> Fix it with this patch
> >>=20
> >> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> >=20
> > Rather than just removing the test, it would be better to still run it
> > using an explicit -t bi to force the byte output.
> 
> Perhaps it wasn't exactly clear in the patch. The old test case output is co=
> mmented out but there is test case output for the new patch.=20
> 
> So the test is not removed.=20

Uh, yeah, something needs to be done here still.
(There is a failing test still.)

Could we get a resubmission of the fix, please?

Thanks,
jdl
