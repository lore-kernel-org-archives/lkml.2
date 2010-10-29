Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815Ab0J2Twj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:52:39 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:41099 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0J2Twf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:52:35 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 15:52:35 EDT
From: James Cloos <cloos@jhcloos.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: How do I add yaffs file system to mainline?
In-Reply-To: <4CC9C386.6010503@oracle.com> (Randy Dunlap's message of "Thu, 28
	Oct 2010 11:40:06 -0700")
References: <201010290455.02390.manningc2@actrix.gen.nz>
	<201010290655.39490.manningc2@actrix.gen.nz>
	<20101028180845.GA2573@kroah.com>
	<201010290738.05632.manningc2@actrix.gen.nz>
	<4CC9C386.6010503@oracle.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 29 Oct 2010 15:16:01 -0400
Message-ID: <m3eib8n71y.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Hashcash: 1:30:101029:randy.dunlap@oracle.com::WvRrlyZa6d0lNtu/:0000000000000000000000000000000000000jG9oq
X-Hashcash: 1:30:101029:manningc2@actrix.gen.nz::WqKrqXpZdourhQZb:0000000000000000000000000000000000000Y9Ifu
X-Hashcash: 1:30:101029:greg@kroah.com::u4i0WHypOlV1NY7F:00WaBu7
X-Hashcash: 1:30:101029:linux-kernel@vger.kernel.org::WFvij2mRnRIKHOHB:00000000000000000000000000000000qSxlx
X-Hashcash: 1:30:101029:sfr@canb.auug.org.au::SRcFFA2CTnVX3uV3:0000000000000000000000000000000000000000nn41Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "RD" == Randy Dunlap <randy.dunlap@oracle.com> writes:

RD> How big is the patch (in KB, not lines of code)?

Being the curious sort:

:; git clone --reference /pub/scm/linux/kernel/git/torvalds/linux-2.6.git git://github.com/cdhmanning/linux-yaffs-integration.git
Cloning into linux-yaffs-integration...
remote: Counting objects: 55, done.
remote: Compressing objects: 100% (50/50), done.
remote: Total 51 (delta 1), reused 51 (delta 1)
Receiving objects: 100% (51/51), 128.48 KiB, done.
Resolving deltas: 100% (1/1), done.
:; cd linux-yaffs-integration
:; git show | wc
  17094   64514  448590

(It looks like the repo has only the one commit not also in Linus' tree,
rather than a series of commits to add yaffs.)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
