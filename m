Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2EYOLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:11:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60274 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2EYOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:11:29 -0400
Date: Fri, 25 May 2012 15:13:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        randy.dunlap@oracle.com, mjg59@srcf.ucam.org, gregkh@suse.de,
        trenn@suse.de, Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de,
        airlied@redhat.com, eric@anholt.net, alexdeucher@gmail.com,
        bskeggs@redhat.com, chris@chris-wilson.co.uk
Subject: Re: [PATCH] gpu: schedule gma500 stub driver for feature removal
Message-ID: <20120525151354.4912e458@pyramind.ukuu.org.uk>
In-Reply-To: <20120524195350.GA11545@kroah.com>
References: <1337613816-12953-1-git-send-email-jlee@suse.com>
	<20120524195350.GA11545@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 04:53:50 +0900
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, May 21, 2012 at 11:23:36PM +0800, Lee, Chun-Yi wrote:
> > In v3.3, the gma500 drm driver moved from staging to drm group by
> > Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> > brightness well and don't need gma500 stub driver anymore.
> > 
> > So, my plan is remove gma500 stub driver at Dec. 2012.
> 
> Why not just remove it right now as it's not needed at all anymore?

If there are distros not currently ahipping the GMA500 driver or people
updating old kernels using vesa and not having the right server bits it
might cause them problems - giving it 6 months isn't a bad idea IMHO
