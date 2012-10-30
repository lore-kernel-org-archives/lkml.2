Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074Ab2J3RD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:03:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:10863 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab2J3RD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:03:26 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3c7sfw==
X-RZG-CLASS-ID: mo00
Date: Tue, 30 Oct 2012 18:03:21 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v4] xen PVonHVM: move shared_info to reserved
 memory area
Message-ID: <20121030170321.GA1251@aepfle.de>
References: <1351612057-21822-1-git-send-email-olaf@aepfle.de>
 <50900B1D02000078000A586C@nat28.tlf.novell.com>
 <20121030163006.GA26404@aepfle.de>
 <5090124C02000078000A58AC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5090124C02000078000A58AC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, Jan Beulich wrote:

> And iirc you're doing this relocation because otherwise the newly
> booting kernel image may get overwritten at an (from its
> perspective) arbitrary location. What I'm trying to point out is
> that the shared info structure is not the only thing (potentially)
> inside the kernel image that might get overwritten - the relocated
> (by the old kernel) vCPU info may as well. Plus I think the new
> kernel has no way of relocating it a second time (including back
> into the shared info structure) with how the hypervisor works at
> present.

Thanks, I have not looked at this, nor was I aware of it until now.
I will see what needs to be done.

Is this also an issue with the xenlinux based PVonHVM code?


Olaf
