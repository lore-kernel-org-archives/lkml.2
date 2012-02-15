Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2BOWPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:15:40 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:20292 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755115Ab2BOWPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:15:39 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: C6c1ef8VM1mJyegP2TDEkmiXzPeUT1iVXdffGp2NJlwT5QB
 h.fkqwgL7LrjBrP99NuSEfePxso_jIoO8q33zuW4c6NeiUN2rFqGNRmcIk7v
 ebaJgHJlS2ddZUivJ9h5SwD_tldPBxoGT4ZOn.HJz.QWgL7oYka3alvk1AmV
 NrczvuaBrf6Trltlp8r9fhNopqn3mfrFgiBj0K97GHBICPYndtWiL_VhfUGp
 gExedy6nNsyhXJB18_k4a2Nk1xufdRWX4XRz2cKnZ_2oPDGVlR78iZyrj6Mi
 sgnjp7AQWYhh0kuC70Mu.HCBEjNxWe7tLzDtJcrlnxBR1SH7J2HvdFylbPLm
 UMHdhMtEQJEAH3Cn3gjNe3_GBBavneGJPrmK8nR0KNfayGY9HOZ7FSyBMvlx
 dsVwt3NcXbuZjFMm_2R.f6jTzxI2vzQlYf2upEqfIKKvSBm01BDrcwpF1Ea4
 Wxzz2gcX_3zuMMG9K4wxPGnsp1Q6h5raYuaNwC1cISx20zOZskRgeejvbyGL
 Yxzg-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 15 Feb 2012 16:15:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
In-Reply-To: <4F3C28AF.9080005@tilera.com>
Message-ID: <alpine.DEB.2.00.1202151614510.28225@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>  <1327591185.2446.102.camel@twins>  <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>  <20120201170443.GE6731@somewhere.redhat.com>  <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
  <4F2AAEB9.9070302@tilera.com> <1328898816.25989.33.camel@laptop> <4F3C28AF.9080005@tilera.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Chris Metcalf wrote:

> The Tilera dataplane code is available on the "dataplane" branch (off of
> 3.3-rc3 at the moment):
>
> git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git

Looks like that patch is only for the tile architecture. Is there a
x86 version?
