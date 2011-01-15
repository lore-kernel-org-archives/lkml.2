Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1AOPfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:35:34 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37428 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890Ab1AOPfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:35:33 -0500
Subject: Change in parisc tree source for Linux Next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 09:35:31 -0600
Message-ID: <1295105731.5973.25.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

We've had a change of maintainer over at parisc and a consequent tree
change.  Could you replace

git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git#next

with

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#for-next

as the parisc tree for inclusion in linux next.

Hopefully, there won't be any issues with it, but if there are, please
send them directly to the parisc list (we have multiple maintainers, so
one of us will see and sort it out).

Parisc List <linux-parisc@vger.kernel.org>

Thanks,

James


