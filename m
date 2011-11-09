Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab1KIIf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:35:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1KIIf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:35:56 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNP ACPI: Use real gsi
Date: Wed, 9 Nov 2011 09:35:51 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bhelgaas@google.com,
        lenb@kernel.org, stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>
References: <1320372728-3235-1-git-send-email-trenn@suse.de> <1320373233-3725-1-git-send-email-trenn@suse.de>
In-Reply-To: <1320373233-3725-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201111090935.52141.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, November 04, 2011 03:20:33 AM Thomas Renninger wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
...
> On an IBM Xseries (x3850) this caused the machine to freeze around when
> the init userspace process is tried to get started.
> The reason is that the timer interrupt is not set up correctly on this
> machine.
...

What is the state/opinion about this one?
It fixes a sever bug/regression for me and it would be great to
see this one in 3.2.

Thanks,

    Thomas
