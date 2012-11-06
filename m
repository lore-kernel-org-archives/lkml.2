Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2KFOoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:44:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55216 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2KFOoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:44:02 -0500
Date: Tue, 6 Nov 2012 15:44:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Do not change worker's running cpu in
 cmci_rediscover().
Message-ID: <20121106144405.GC9558@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tang Chen <tangchen@cn.fujitsu.com>, tony.luck@intel.com,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
	x86@kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1351479710-9144-1-git-send-email-tangchen@cn.fujitsu.com>
 <5098F1C6.1010602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5098F1C6.1010602@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 07:17:26PM +0800, Tang Chen wrote:
> Hi Tony, Borislav,
> 
> Would you please help to review this patch ?

I'm guessing mingo or hpa haven't pulled yet:

http://marc.info/?l=linux-kernel&m=135163452500984

Thanks.

-- 
Regards/Gruss,
Boris.
