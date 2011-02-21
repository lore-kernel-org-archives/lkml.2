Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab1BUVnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:43:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1BUVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:43:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: merge of m68knommu and m68k arch branches?
Date: Mon, 21 Feb 2011 22:43:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
References: <4D5DB83D.80205@snapgear.com> <20110218074401.GA26836@merkur.ravnborg.org> <4D5E5FB1.1000404@snapgear.com>
In-Reply-To: <4D5E5FB1.1000404@snapgear.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102212243.15867.arnd@arndb.de>
X-Provags-ID: V02:K0:R/ZTgl1Mq2xkFBotoFmhuhPrygqrpOTc86N9KYPsDY6
 1GsiS1fMFf2DoxC+nNWBH1MV3GrQ0V/boNxWs1HZVcL0NIeF/r
 2XDNKXwNDAuj02NmCV07s7iIsZoxy5YfaUIqylJQnd4TX8TPZ6
 kTvyOxtXb3sOF0mHRUO6iRv2dLIW9lBebqDrWf5eeRqUff5azB
 fuuoXcaa5hzwbBwPiOxCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011 13:01:53 Greg Ungerer wrote:
> >> Attached is a script and patch that does a kind of brute force
> >> simplistic merge of the directories and files. (Thanks to Stephen King
> >> <sfking@fdwdc.com>  for the initial version of this script, and to
> >> Sam Ravnborg for the m68k includes merge script this was based on).
> >> Nothing outside of the arch/m68k and arch/m68knommu directories is
> >> touched, and in the end there is no more arch/m68knommu. To apply you
> >> simply run the script from the top of a current kernel git tree (I used
> >> 2.6.38-rc5 for testing) and then apply the patch.
> >
> > The initial version of said script was created by Arnd IIRC.
> 
> Apologies to Arnd then :-)

I had absolutely no memory of having done said script, but if Sam
says wrote it did, that's probably true.

I was just about to say how much I like your script when I read
that it was my idea...

	Arnd
