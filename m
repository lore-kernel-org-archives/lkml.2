Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785Ab0J0BJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:09:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42419 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760761Ab0J0BJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:09:14 -0400
X-Sasl-enc: /1e6ip9nS4OSmXbuxcDbYAusxd3j8GHBXAnK96bOg22A 1288141753
Date: Tue, 26 Oct 2010 23:09:08 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julia Lawall <julia@diku.dk>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete
 double assignment
Message-ID: <20101027010908.GA29299@khazad-dum.debian.net>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-9-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288088743-3725-9-git-send-email-julia@diku.dk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete successive assignments to the same location.

There are often results of mismerges or other assorted screw ups, often
done by the maintainer itself (e.g. me in thinkpad-acpi's case) during
development.

The patch is correct, and I thank you for the head's up.  But let me
track down what caused it first, hmm?  I also highly recommend that this
should be done in all cases you find, instead of just blindly fixing the
assignment.  I suggest using git --blame to track down what added the
duplicated assignments, and check if it looks sane...

It is often a VERY BAD IDEA to remove such markers of potential
brokennes without checking out if they're actually helpfully trying to
warn you of worse badness :p

But hey, maybe you've already done that.  If you did, I apologise for
preaching to the choir.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
