Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1AURuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:50:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1AURuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:50:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lVKZvKNUteAGVPIb4T+qL2zVD/me9nJpjesaAR5VZBSBQe/RUwq0+YU2xVQQ1jv3kI
         J8O0aOVoeDlcCzu2NBCV7k6ToomUhL8784GgSszBGk1ZRHqO5jKpgg/63W1ZqPxI69+X
         EOaF8Bp3+RA8awuSsQtZi0J5K12WKJSb/Vp88=
Date: Fri, 21 Jan 2011 18:50:06 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu fixes for v2.6.38-rc1
Message-ID: <20110121175006.GN2832@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu fixes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git fixes-2.6.38

It contains only one patch which fixes a problem which could,
theoretically, lead to build failure on 32bit.

Christoph Lameter (1):
      x86,percpu: Move out of place 64 bit ops into X86_64 section

 arch/x86/include/asm/percpu.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Thanks.

--
tejun
