Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955Ab1JEQRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:17:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61032 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934476Ab1JEQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:16:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v4 00/24] C6X: New architecture
Date: Wed, 5 Oct 2011 18:16:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <3214215.H2jdYLnAju@wuerfel> <1317819123.2703.8.camel@deneb.redhat.com>
In-Reply-To: <1317819123.2703.8.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051816.44080.arnd@arndb.de>
X-Provags-ID: V02:K0:6yG98LoWUDwJfygsA1dMTI56qLV7w+Xnzn+s9CJ3OWU
 DeFp8C9LldwGwee37hHBfcMB8RIRa31qgfLQ0faspRAXHMae/i
 jnNlxm6jZ07nZdGWMKE/XBbb8MBTzV6Q9KXwPUwglWJRe1mQqN
 Jizo90DfIGvczmtq1af84Zqb2NBDvoEVDd6Nu8sXYhCXRQRZRO
 le++ucu/Be1lit4ZCKgEFzzHLN0pawORDIYDB4x8v2+N8/ILUK
 G/mKiE8V2qqlCfmKbb01Q5q+yJqG/p7AF4pdnND3FXCwInA7sl
 iX/0PDPyy9tZemLU/D5kP/6h9neJj3IRGfl99CzDaPqvxaT/iw
 p6Lgi/iw89f+bvU4Q/i0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 October 2011, Mark Salter wrote:
> On Tue, 2011-10-04 at 21:27 +0200, Arnd Bergmann wrote:
> > On Tuesday 04 October 2011 12:43:37 Mark Salter wrote:
> > > Here is v4 of the C6X architecture patch series. Patches are
> > > available in 'for-linux-next' branch at:
> > > 
> > >     http://linux-c6x.org/git/projects/linux-c6x-upstreaming.git
> > 
> > Hi Mark,
> > 
> > This looks all good to me, great work!
> > 
> >       Arnd
> 
> Thanks! So what is the next step?

Easy:
* Make sure the code is in linux-next
* Make sure that linux-next actually still works for you, with everything else that 
  went in
* Wait for Linus to open the merge window, then send him a pull request,
  with the same Cc list as this review.

Once everything is merged, you are alone responsible for deciding what
goes in, but we will be there to give advice when needed.

	Arnd
