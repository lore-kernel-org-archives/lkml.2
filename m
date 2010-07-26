Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0GZP4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:56:34 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:57683 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0GZP4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:56:33 -0400
Date: Mon, 26 Jul 2010 17:56:27 +0200
From: Nils Radtke <Nils.Radtke@Think-Future.de>
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cryptsetup + lvm on usb disk, unusable /dev/dm-* after
 suspend/resume   cycle
Message-ID: <20100726155627.GN31966@localhost>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
References: <20100725160641.GK31966@localhost>
 <4C4CA601.6020201@redhat.com>
 <20100726130605.GL31966@localhost>
 <4C4D8C25.8040704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4D8C25.8040704@redhat.com>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Milan,

  Thank you for your explanation.

  So I'll try to find logs regarding this issue (won't be easy though..).

  On the other hand, the usb device survives suspend/resume normally, that is,
  when using a plain disk, std partition etc.

  Ok, I'm going for the logs and if found be back.

  Thank you again for your help.


                  Nils



On Mon 2010-07-26 @ 03-22-45PM +0200, Milan Broz wrote: 
# On 07/26/2010 03:06 PM, Nils Radtke wrote:
# > That's what I tried and failed gloriously. I'm trying to revive my memory about the 
# > situation: fs could be unmounted, however, the cryptsetup luksClose failed (IRC) and 
# > therefore the dmsetup remove consequently failed also.
# 
# So instead of "cryptsetup luksClose" use dmsetup remove for crypt device too
# (There was a bug in some version of cryptsetup which failed close if underlying device
# disappeared, should be fixed in >=1.1.2, anyway "dmsetup remove" is low-level equivalent.)
# 
# Also see man page and "dmsetup remove -f" flag.
# 
# The usb device reinitialization is separate problem, maybe someone can help if you provide
# more logs.
# 
# Milan

