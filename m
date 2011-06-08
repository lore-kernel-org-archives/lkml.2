Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1FHM24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:28:56 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:49047 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751627Ab1FHM2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:28:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DES3nR8VM1nczQCMV1MUTcTf2UWNgBqNA.jLhekDLuoIH13
 kpSl51uXBBam1mxWtZ7IxyAqobAE5VnAOGIgqPqbYDC0CGrtvMjU484YPTiD
 cgvAe0mgGV8XyaJity8FUXjIFu1Zhxsc35K5l7PESmbc7y_3J4b50gQV0EGo
 lJ3YyL0ob72wUxGa7CT9rq5gPupFR_KL6WWxxgMPiny5YYZHplgpQvEHeHV_
 ybl.5kFMYLcsybEKNifOu5HCclhD0f_vWXtMAqofbGRagcETlzMcB9yNnsE.
 isvCeyQqBhxlgQOw4YcLSz2dOCTtBLoHclg6YDIdLFCLIw7kl
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Jun 2011 07:28:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: Readd asmregparm
In-Reply-To: <BANLkTimZ65o-gRf8n3SRzTedd=fTCB55QQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106080719000.9853@router.home>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org> <20110608081957.GA14966@elte.hu> <20110608083750.GH27166@one.firstfloor.org> <BANLkTimZ65o-gRf8n3SRzTedd=fTCB55QQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Pekka Enberg wrote:

> Hi Andi,
>
> On Wed, Jun 8, 2011 at 11:37 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> That's a totally useless changelog (you are deliberately hiding
> >> information again) so the series is obviously not acceptable.
> >> Please fix and resend.
> >
> > I reread it and it seems complete to me. Please be more specific.
> >
> > If you refer to the followon patchkit - it's not ready for posting
> > yet. However I believe these changes are reasonable cleanups that are useful
> > on their own. That's why I posted them now.
>
> So from my point of view, none of the changelogs explain why the
> changes needed. Now, I'm not an expert on the x86 code so maybe I'm
> missing something obvious but to me the only rationale seems to be
> that you need it some unspecified follow-up patchkit. HTH.

Ok but the changelog is explaining the patch as far as I can tell. Its
just that there is not enough of a justification for inclusion without the
follow on patches and clarity on the ultimate purpose of the whole
endeavor. In general some more specificity and less emotions may be
helpful.



