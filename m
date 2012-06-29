Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2F2NDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:03:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab2F2NDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:03:47 -0400
Date: Fri, 29 Jun 2012 15:03:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the hid tree
In-Reply-To: <20120629124731.4577c98083269ca2d20c8d5f@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1206291503010.11491@pobox.suse.cz>
References: <20120629124731.4577c98083269ca2d20c8d5f@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012, Stephen Rothwell wrote:

> After merging the hid tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/hid/Kconfig:698: unexpected 'endif' within menu block
> drivers/hid/Kconfig:702: unexpected 'endmenu' within if block
> drivers/Kconfig:151: 'endmenu' in different file than 'menu'
> drivers/hid/Kconfig:79: location of the 'menu'
> arch/powerpc/kvm/Kconfig:153: syntax error
> drivers/Kconfig:1: missing end statement for this entry
> 
> Caused by bad merge 8494746044bf ("Merge branch 'roccat' into
> for-next").  This added a second copy of
> 
> menu "Special HID drivers"
> 
> I have used the hid tree from next-20120628 for today.

Thanks for reporting this, Stephen; I have mismerged the branch. Just 
pushed out fixed branch, so all should be okay now.

Thanks,

-- 
Jiri Kosina
SUSE Labs
