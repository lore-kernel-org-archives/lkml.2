Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2EUIqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:46:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58964 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab2EUIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:46:32 -0400
Date: Mon, 21 May 2012 10:46:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 1/2] x86: Define early read-mostly per-cpu macros
Message-ID: <20120521084626.GD31407@gmail.com>
References: <1337527154.6093.15.camel@vlad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337527154.6093.15.camel@vlad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> Some read-mostly per-cpu data may need to be declared or defined early,
> so it can be initialized and accessed before per_cpu areas are
> allocated.
> 
> Only the data that resides in the per_cpu areas should be read-mostly,
> as there is little benefit in optimizing cache lines on initialization.
> 
> Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>

That's not a valid signoff chain. If you send me a patch then 
you should be the last SOB - but as the author you should be the 
first SOB as well. I edited the two SOBs to be Acked-by's.

Thanks,

	Ingo
