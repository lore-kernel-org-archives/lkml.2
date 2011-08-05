Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1HESO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:14:56 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:25522 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754193Ab1HESOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:14:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eHAO9j4VM1lUmC_dqcgCFNXEgaPRGNypdIcy0FUjX37fWDx
 VpCuVfeihOTgO41BNKp6BKCiG4hvy8CLpj8YsyQzRv_N48enn.qD4nqS4xRB
 hOt8AFJPbK0887v_3RSB4bGYSsc3dxD6ymNL09qFiTPEEd2kyBQcBFv7apX9
 43o5egr0LPs.BRI7Y6.eKU.ZePh_N6W2nKI45BaOjftDjGhODV1rNejXxALz
 lNDz2Otv1WND34iW1XsYfZbsISbdzxALYtcfkGAHu7Zj9T3lYJ3nB2NfR6GO
 U7q6yggMr8a4SrzxmbMF5hCGyPxL1UosQS0CCeNpEh9qlYBpxL_brDxkUCWE
 uArVoGDkrX4IAxsAh1WfBVi8xOukNeVOeoUYA4kDnRv9S.JSQiqda_ModG4p
 jn7srsVXOMEc2KWKkRsH3yg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 13:14:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <20110805171607.GA11703@redhat.com>
Message-ID: <alpine.DEB.2.00.1108051312090.28580@router.home>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com> <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com> <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, Dave Jones wrote:

>  > Argh another debugging code issue. Anyone who sees this please verify that
>  > it also occurs with debugging off. I ran this code for 9 months in
>  > various configs but only sporadically with debugging support since that
>  > switches the lockless stuff.
>
> This started turning up immediately as soon as it got merged to mainline.
> Which leads me to believe no-one is running -next with debugging on either.
> Perhaps we should force debugging on for a week once per release cycle.

I have run some tests over the last hours with kvm and
CONFIG_SLUB_DEBUG_ON as well as CONFIG_DEBUG_LIST set but (aside from
other unrelated backtraces in other subsystems) did not see this issue.

Can I get a .config? Maybe that will help.


