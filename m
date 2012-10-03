Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2JCTrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:47:00 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:5929 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2JCTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:46:58 -0400
Date: Wed, 3 Oct 2012 15:46:14 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003194614.GA2893@elliptictech.com>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-30 17:38 -0700, Linus Torvalds wrote:
> So here it is, 3.6 final. Sure, I'd have been happier with even fewer
> changes, but that just never happens. And holding off the release
> until people get too bored to send me the small stuff just makes the
> next merge window more painful.

Just upgraded to 3.6 from 3.5, and now some of my kernel build scripts
are throwing "permission denied" errors.  Apparently symlinks are
broken somehow?

  # id
  uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)

  # ls -l /scratch_space/linux
  drwxr-xr-x 24 nbowler eng 4096 2012-10-03 13:41 /scratch_space/linux

  # readlink /scratch_space/linux-2.6
  linux

  # cd /scratch_space/linux
  # pwd
  /scratch_space/linux

  # cd /scratch_space/linux-2.6
  cd: permission denied: /scratch_space/linux-2.6

WTF?  3.5 is fine.  I will try to bisect this later, but I figured I'd
throw this out there now in case anyone has any ideas...

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

