Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab1JDOE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab1JDOE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:04:58 -0400
Date: Tue, 4 Oct 2011 10:04:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111004140437.GA28306@redhat.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003073203.GA22694@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 01:02:03PM +0530, K.Prasad wrote:
> There are certain types of crashes induced by faulty hardware in which
> capturing crashing kernel's memory (through kdump) makes no sense (or sometimes
> dangerous).
> 
> A case in point, is unrecoverable memory errors (resulting in fatal machine
> check exceptions) in which reading from the faulty memory location from the
> kexec'ed kernel will cause double fault and system reset (leaving no
> information for the user).

Prasad,

I am just trying to remember what was wrong with Andi's approach of
disable MCE while copying the dump?

Thanks
Vivek
