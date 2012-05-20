Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2ETQM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:12:58 -0400
Received: from plane.gmane.org ([80.91.229.3]:38374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2ETQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:12:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Akemi Yagi <amyagi@gmail.com>
Subject: Re: 3.3.6 boot failure regression
Date: Sun, 20 May 2012 16:12:43 +0000 (UTC)
Message-ID: <jpb55r$8po$1@dough.gmane.org>
References: <CADLC3L0kMzakdQunStegKeYmp5vxTCniNjrQFocKpJ5qSNeSxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: energy.scripps.edu
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 09:52:59 -0600, Robert Hancock wrote:

> On an HP Elite 8200 machine (Intel Sandy Bridge CPU, Cougar Point
> chipset), 3.3.6 hangs up on boot right after "Probing EDD.. ok". There
> is no more output after that, though it does respond to Ctrl-Alt-Del to
> reboot. 3.3.5 worked fine. I am using the kernel-ml RPM builds from
> ELRepo for Scientific Linux 6.
> 
> Any suggestions on boot options, etc. to help narrow it down? Compiling
> a custom kernel would be somewhat inconvenient on this machine.

Robert,

I forwarded your post to the maintainer of ELRepo's kernel-ml, Alan 
Bartlett. He has now released kernel-ml-3.3.6-2.el6.elrepo. Please test 
this version.

In the future, if you encounter any issue with kernel-ml, please post to 
ELRepo's mailing list or bug tracker, not this list because this is not 
related to the kernel code but rather a configuration issue.

Akemi

