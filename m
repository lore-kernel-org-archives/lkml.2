Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0JCS7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:59:45 -0400
Received: from smtp.witbe.net ([81.88.96.48]:41699 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0JCS7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:59:44 -0400
Date: Sun, 3 Oct 2010 20:59:11 +0200
From: Paul Rolland <rol@as2917.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm: Prune GEM vma entries
Message-ID: <20101003205911.073883c3@tux.DEF.witbe.net>
In-Reply-To: <1285978196.16634.1392.camel@calx>
References: <20100927115207.633024b1.akpm@linux-foundation.org>
	<1285618116-10086-1-git-send-email-chris@chris-wilson.co.uk>
	<1285978196.16634.1392.camel@calx>
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

On Fri, 01 Oct 2010 19:09:56 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, 2010-09-27 at 21:08 +0100, Chris Wilson wrote:
> > Hook the GEM vm open/close ops into the generic drm vm open/close so
> > that the vma entries are created and destroy appropriately.
> > 
> > Reported-by: Matt Mackall <mpm@selenic.com>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> All signs point to this being the correct fix, but I won't have time to
> test it while I'm in Japan.
> 
> Paul, does this work for you?

I've just finished building a kernel with this patch applied.
I now need to keep it running for at least one day to make sure that the
leak is gone for good.

I'll keep you updated on that.

Regards,
Paul
