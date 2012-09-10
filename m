Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2IJOCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:02:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41263 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756958Ab2IJOCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:02:31 -0400
Date: Mon, 10 Sep 2012 15:01:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/31] arm64: System calls handling
Message-ID: <20120910140148.GD27042@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <201209071943.37184.arnd@arndb.de>
 <20120910095619.GA27042@arm.com>
 <201209101351.52902.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209101351.52902.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 02:51:52PM +0100, Arnd Bergmann wrote:
> On Monday 10 September 2012, Catalin Marinas wrote:
> > Yes, I've seen these but since Al's patches are not in mainline, I don't
> > want to add additional dependencies to the arm64 patches (currently
> > based on 3.6-rc4). Once they get into mainline, I'll add a patch that
> > converts arm64 to the generic functions above.
> > 
> > For kernel_execve(), I think I can simplify it further and not rely on
> > Al's patches (similar to other architectures doing an SVC from kernel):
> 
> Hmm, I thought one of the reasons for Al to do his series was to discourage
> people from doing syscalls from kernel space, but I may be misremembering
> things. Al?

If that was the aim, I'm happy to change the code similar to the
arch/arm one. But as I said I would wait until Al's patches get into
mainline.

-- 
Catalin
