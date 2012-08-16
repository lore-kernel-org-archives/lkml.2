Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2HPNsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:48:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50212 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab2HPNsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:48:36 -0400
Date: Thu, 16 Aug 2012 15:48:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomas Racek <tracek@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: x86, nops settings result in kernel crash
Message-ID: <20120816134834.GA11974@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tomas Racek <tracek@redhat.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
	qemu-devel@nongnu.org
References: <1104118228.1760802.1345121009530.JavaMail.root@redhat.com>
 <711271179.1776875.1345124112800.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <711271179.1776875.1345124112800.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 09:35:12AM -0400, Tomas Racek wrote:
> Hi,
> 
> I am writing a file system test which I execute in qemu with kernel compiled from latest git sources and running it causes this error:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=45971
> 
> It works with v3.5, so I ran git bisect which pointed me to:
> 
> d6250a3f12edb3a86db9598ffeca3de8b4a219e9 x86, nops: Missing break resulting in incorrect selection on Intel
> 
> To be quite honest, I don't understand this stuff much but I tried to do some debugging and I figured out (I hope) that the crash is caused by setting ideal_nops to p6_nops (k8_nops was used before the break statement was added).

Maybe I overlooked it or maybe it was implied but did you try reverting
the patch and rerunning your test? Does it work ok then?

Thanks.

-- 
Regards/Gruss,
Boris.
