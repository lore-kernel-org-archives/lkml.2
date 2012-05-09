Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab2EIIWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:22:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47489 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2EIIW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:22:29 -0400
Date: Wed, 9 May 2012 11:22:25 +0300
From: Ido Yariv <ido@wizery.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] vsmp: Fix number of CPUs when vsmp is disabled
Message-ID: <20120509082225.GB5036@NoteStation.colubris.lan>
References: <1336462455-22544-1-git-send-email-ido@wizery.com>
 <tip-824a6ae65f085255464155760cb9628a2f0deb29@git.kernel.org>
 <20120508122548.GA5741@gmail.com>
 <20120509080335.GA5556@NoteStation.colubris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509080335.GA5556@NoteStation.colubris.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:03:35AM +0300, Ido Yariv wrote:
> +#ifdef CONFIG_X86_VSMP
> +	/* VSMP is enabled, no need to cap cpus */
> +	return;
> +#elif CONFIG_SMP

I've missed a 'defined' here. I'll send a new version right away.

Thanks,
Ido.
