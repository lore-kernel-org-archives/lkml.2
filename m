Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217Ab1JERoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:44:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48945 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934662Ab1JERoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:44:02 -0400
Date: Wed, 5 Oct 2011 19:43:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "crash-utility@redhat.com" <crash-utility@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "tachibana@mxm.nes.nec.co.jp" <tachibana@mxm.nes.nec.co.jp>,
        "oomichi@mxs.nes.nec.co.jp" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005174358.GE18592@gere.osrc.amd.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004143012.GB28306@redhat.com>
 <20111005074116.GC2235@in.ibm.com>
 <20111005154011.GD30146@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE62D58D@orsmsx505.amr.corp.intel.com>
 <20111005171007.GF30146@redhat.com>
 <20111005172036.GD18592@gere.osrc.amd.com>
 <20111005172912.GI30146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005172912.GI30146@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 01:29:12PM -0400, Vivek Goyal wrote:
> As long as you can get to your struct page arrays, one should be able
> to filter out poisoned pages without saving the whole dump.

Ok, this sounds good.

So, maybe the tool should be taught to always skip poisoned pages due to
danger of follow-up MCEs and, when kexec has rebooted due to an MCE, to
warn before doing a vmcore dump that the dump might not contain useful
information or that the dumping itself could result in further MCEs and
whether the user still wants to proceed.

Or something to that effect.

Thanks.

-- 
Regards/Gruss,
Boris.
