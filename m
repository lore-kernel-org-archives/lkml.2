Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2H3Idy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:33:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49017 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751358Ab2H3Idw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:33:52 -0400
Message-ID: <1346315631.2103.35.camel@joe2Laptop>
Subject: Re: [PATCH] MAINTAINERS: fix TXT maintainer list and source repo
 path
From: Joe Perches <joe@perches.com>
To: gang.wei@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, joseph.cihula@intel.com, hpa@zytor.com,
        richard.l.maliszewski@intel.com, shane.wang@intel.com,
        tboot-devel@lists.sourceforge.net, mingo@redhat.com,
        tglx@linutronix.de
Date: Thu, 30 Aug 2012 01:33:51 -0700
In-Reply-To: <1346303976-26721-1-git-send-email-gang.wei@intel.com>
References: <1346303976-26721-1-git-send-email-gang.wei@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 13:19 +0800, gang.wei@intel.com wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
>  INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
[]
> -T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg
> +T:	Mercurial http://tboot.hg.sourceforge.net:8000/hgroot/tboot/tboot

Perhaps this would be better as:
T:	hg http://tboot.hg.sourceforge.net:8000/hgroot/tboot/tboot

>From the MAINTAINERS introduction:

Descriptions of section entries:
[]
T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.


