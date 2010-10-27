Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab0J0Vmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:42:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42499 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932602Ab0J0Vmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:42:43 -0400
X-Sasl-enc: EwQudh5vVStVveI03hx73VxhjYkZONxrdR+PWdJyQKPK 1288215762
Date: Wed, 27 Oct 2010 19:42:37 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete
 double assignment
Message-ID: <20101027214237.GD27847@khazad-dum.debian.net>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-9-git-send-email-julia@diku.dk>
 <20101027010908.GA29299@khazad-dum.debian.net>
 <20101027035449.GB6062@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027035449.GB6062@bicker>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Dan Carpenter wrote:
> On Tue, Oct 26, 2010 at 11:09:08PM -0200, Henrique de Moraes Holschuh wrote:
> > On Tue, 26 Oct 2010, Julia Lawall wrote:
> > > From: Julia Lawall <julia@diku.dk>
> > > 
> > > Delete successive assignments to the same location.
> > 
> > There are often results of mismerges or other assorted screw ups, often
> > done by the maintainer itself (e.g. me in thinkpad-acpi's case) during
> > development.
> > 
> > The patch is correct, and I thank you for the head's up.  But let me
> > track down what caused it first, hmm?  I also highly recommend that this
> > should be done in all cases you find, instead of just blindly fixing the
> > assignment.
> 
> I've reviewed the entire patchset per your suggestion and Julia
> obviously didn't do it blindly.  It all looks good.  The patcheset fixes
> a number of bugs.

Thank you, Dan and Julia.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
