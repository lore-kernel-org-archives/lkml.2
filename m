Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1CQRjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:39:01 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53398 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1CQRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:38:59 -0400
X-IronPort-AV: E=Sophos;i="4.63,200,1299456000"; 
   d="scan'208";a="4847203"
Date: Thu, 17 Mar 2011 17:38:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@elte.hu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL tip/x86/mm] xen/x86 fixes
In-Reply-To: <4D8243F6.4030105@kernel.org>
Message-ID: <alpine.DEB.2.00.1103171737550.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop> <20110311222129.GA3168@dumpdata.com> <alpine.DEB.2.00.1103161150010.3382@kaball-desktop> <alpine.DEB.2.00.1103171237190.3382@kaball-desktop> <4D8243F6.4030105@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Yinghai Lu wrote:
> > Should I send another git pull request for tip even though the two
> > patches on linux-tip that this series was depending on have gone
> > upstream?
> >
> > x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
> > x86-64, mm: Put early page table high
> >
> > Should I send the git pull request to Linus instead?
> 
> can you please resend the pull request to Ingo and HPA?
> 
> better to make those patches go through tip and pass Ingo's test matrix.

OK, I'll send another pull request.
