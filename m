Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0IYKWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:22:21 -0400
Received: from smtp.witbe.net ([81.88.96.48]:35575 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab0IYKWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:22:20 -0400
Date: Sat, 25 Sep 2010 12:22:03 +0200
From: Paul Rolland <rol@as2917.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.36-rc2 : slabtop report 10170292 size-32 objects...
Message-ID: <20100925122203.062fc9b6@tux.DEF.witbe.net>
In-Reply-To: <1283965167.2964.17.camel@calx>
References: <20100901113525.04b356c5@tux.DEF.witbe.net>
	<AANLkTimnBG1qcLwZoEkr_iDkwE4zygLdjFJHVk9S3+wZ@mail.gmail.com>
	<20100901115507.705fe5e4@tux.DEF.witbe.net>
	<1283965167.2964.17.camel@calx>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 08 Sep 2010 11:59:27 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Wed, 2010-09-01 at 11:55 +0200, Paul Rolland wrote:
> > Hi Pekka,
> > 
> > > Might be related to this:
> > > 
> > > http://kerneltrap.org/mailarchive/linux-kernel/2010/8/25/4611329
> >  
> > Yes, considering that lspci also confirms my machine has some common
> > points with Matt's one :
> 
> For the record, I'm using a conventional 2D window manager so the leak
> is somewhere in that path.
> 
For the record too, I'm currently running 2.6.36-rc5, and the problem's
still there...

Paul
