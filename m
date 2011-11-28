Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1K1LcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:32:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53245 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519Ab1K1Lb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:31:59 -0500
Date: Mon, 28 Nov 2011 11:33:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Rob Clark <rob.clark@linaro.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20111128113323.7d272081@lxorguk.ukuu.org.uk>
In-Reply-To: <20111128135204.33bb929d7495d7830d09dfc3@canb.auug.org.au>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
	<20111128135204.33bb929d7495d7830d09dfc3@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then if you are moving a driver out of staging, you should put a patch in
> your tree to disable it in staging (or remove it in staging) and send
> that patch to Greg as well.

I was migrating *part* of it. You've forced me to mark it all broken
despite several requests (to which no reply was recieved) not to do so
simply so the poor DRM team can get their work done. As a result anyone
working off Medfield hardware will have to go use other trees. In this
case it's not going to hurt anyone I suspect but who knows in future if
this sort of thing occurs again.

Staging build fail - just mark the staging item as broken, that or stop
including staging in -next.

Alan
