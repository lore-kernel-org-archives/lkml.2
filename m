Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1FNOHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:07:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1FNOHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:07:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
Date: Tue, 14 Jun 2011 16:07:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        rpjday@crashcourse.ca, Grant Likely <grant.likely@secretlab.ca>
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com> <BANLkTi=8bv54-Z=xCyqUhFAnxM5G40k2WQ@mail.gmail.com> <20110610204403.GA13450@kroah.com>
In-Reply-To: <20110610204403.GA13450@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141607.02171.arnd@arndb.de>
X-Provags-ID: V02:K0:o0pF3gZb+3k9gvZJDG5uUj4m4FN1kwJrzrqe+WKlV6W
 jJChV+Q3OLnoC10jppFQp6KYJUudN9oHL6aORhdwYiGb9COEtx
 rXJes8msgWm94TpC80NkIhFqH2Z/PvglhnDL0+pZ/sl0KQ0FxE
 is+mn/LHF7m99hauMOADI+pmeHST0uG6iJkDVomSVmD9JHxTpW
 YC3gd6mHwBwmwQ3Udvcdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 June 2011, Greg KH wrote:
> On Fri, Jun 10, 2011 at 02:29:42PM -0600, Jim Cromie wrote:
> > can someone pick this up,
> > for this release or next ?
> 
> It was rumored that Arnd wanted to take over drivers/char/.

That's true. It probably means I should set up a tree now, before we get
too close to the next merge window.

On the topic of drivers/char/{nsc_gpio,pc8736x_gpio,scx200_gpio}, I wonder
if we should move them to drivers/gpio/nsc_gpio despite the fact that they
use a different (older) interface than all the other gpio drivers.

They have seen only a single non-janitor patch in the last five years,
so I don't think they will be a burden, but it might be nice to have them
in a place where people would actually look for them, with a comment that
they should be converted to the new API in order to be more useful.

	Arnd
