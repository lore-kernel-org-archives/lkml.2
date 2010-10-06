Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab0JFUJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:09:51 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:33837 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759587Ab0JFUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:09:49 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: a961s6QVM1mxgy69t2eSeEcGVtRfw3rU8ssQiJFxQaqDhNV
 fFe51OUmFi3QhdJNV9WFxsusDcYVAREiQbG_ZzboNw30hxiBkDOhbbXVjOKn
 mWHgksMicQxURWg7nE7uhjj02.u4HrZKJRPcpiBA4_1DIyhqlTl02ViaSv4H
 0lFDyE4dij17DDSQC_WRa62dVvvioA4HYXRpSvIsyHX9iKlYICR9SHnK4nVe
 K_iElB3jErk75.jTAlI2oaAL5AAYeRaP.6C84tyj5nkOCLKS.KPsW8susxBb
 f
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Oct 2010 15:09:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 6
In-Reply-To: <4CACCCC3.5070203@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1010061508350.6878@router.home>
References: <20101006163632.c1943a38.sfr@canb.auug.org.au> <AANLkTikxMdXrm1jRztZM1BUAoCbBtAs6A39v1cAgRnDY@mail.gmail.com> <20101006174831.02cf1691.sfr@canb.auug.org.au> <AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com>
 <alpine.DEB.2.00.1010061311430.31538@router.home> <4CACBCDE.3000701@cs.helsinki.fi> <alpine.DEB.2.00.1010061319580.4817@router.home> <4CACCCC3.5070203@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Pekka Enberg wrote:

> On 6.10.2010 21.20, Christoph Lameter wrote:
> > On Wed, 6 Oct 2010, Pekka Enberg wrote:
> >
> > > You already acked my patch to fix it:
> > >
> > > http://lkml.org/lkml/2010/10/6/194
> >
> > That is a different issue.
>
> It's the exact same build error and hotplug_memory_notifier() works just fine
> on !CONFIG_MEMORY_HOTPLUG.

Ahh. I see hotplug_memory_notifier is a macro and the argument just
vanished for !CONFIG_MEMORY_HOTPLUG. You are right.

