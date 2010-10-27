Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab0J0DzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 23:55:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64158 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0J0DzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 23:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=scoPd02MWdaTDd2+ijEirZFgsxmUwvaDL7es8xHFVTvZB7ikkgJoW5zxc31nYWnuBd
         SFvkgh00btiKV0Dw2+V4NYB10pVTLfJBh/Zgm0hKo1u8Ja+xkyd7T3a4cl04up6kApZd
         5xzKafzPruoy7/22sw1wa2YB23rcMuwuU2pVw=
Date: Wed, 27 Oct 2010 05:54:49 +0200
From: Dan Carpenter <error27@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Julia Lawall <julia@diku.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete
	double assignment
Message-ID: <20101027035449.GB6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Julia Lawall <julia@diku.dk>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1288088743-3725-1-git-send-email-julia@diku.dk> <1288088743-3725-9-git-send-email-julia@diku.dk> <20101027010908.GA29299@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027010908.GA29299@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 11:09:08PM -0200, Henrique de Moraes Holschuh wrote:
> On Tue, 26 Oct 2010, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Delete successive assignments to the same location.
> 
> There are often results of mismerges or other assorted screw ups, often
> done by the maintainer itself (e.g. me in thinkpad-acpi's case) during
> development.
> 
> The patch is correct, and I thank you for the head's up.  But let me
> track down what caused it first, hmm?  I also highly recommend that this
> should be done in all cases you find, instead of just blindly fixing the
> assignment.

I've reviewed the entire patchset per your suggestion and Julia
obviously didn't do it blindly.  It all looks good.  The patcheset fixes
a number of bugs.

regards,
dan carpenter

