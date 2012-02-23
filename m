Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2BWHGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:06:20 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56093 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab2BWHGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:06:18 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P3f-9-1pnCRcLmTdt0irjA_JfkXoWrHQD_NtfDemXPoYQ@mail.gmail.com>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	<CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	<20120126232555.GB16330@gamma.logic.tuwien.ac.at>
	<20120127015015.GA23291@gamma.logic.tuwien.ac.at>
	<CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
	<20120222003747.GA9808@gamma.logic.tuwien.ac.at>
	<CAOJsxLENnvYn+xkDufQeTcgbKBsrrf=hw=g_ejCrts7ZNPa-Cg@mail.gmail.com>
	<CANUX_P3f-9-1pnCRcLmTdt0irjA_JfkXoWrHQD_NtfDemXPoYQ@mail.gmail.com>
Date: Thu, 23 Feb 2012 09:06:17 +0200
X-Google-Sender-Auth: eDV5Ca6nyCautNAB-Qi0mdUpHlM
Message-ID: <CAOJsxLHoX2WU7xJ8etXsz32B=QhOADvMzBYzsuBR2YXvv44PyA@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

On Wed, Feb 22, 2012 at 10:54 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Please check this one:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=3d29dd9b5b160ba4542a9b8f869a220559e633a0
>
> it is in 3.3-rc4

I used 3.3-rc4 yesterday and didn't notice the problem with my home
network. Is the patch supposed to fix Norbert's issue as well?

                        Pekka
