Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1CHWNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:13:45 -0500
Received: from www.tglx.de ([62.245.132.106]:37538 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1CHWNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:13:43 -0500
Date: Tue, 8 Mar 2011 23:13:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Micha Nelissen <micha@neli.hopto.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
In-Reply-To: <71ed11a4-aff7-4eb6-b037-0e097bb96444@email.android.com>
Message-ID: <alpine.LFD.2.00.1103082311090.2787@localhost6.localdomain6>
References: <4D583E31.4070507@neli.hopto.org> <20110304103634.4641ae36@jbarnes-desktop> <4D714357.3010807@neli.hopto.org> <alpine.LFD.2.00.1103082143460.2787@localhost6.localdomain6> <35bd5f56-658b-48e3-a376-b07350a29cf6@email.android.com>
 <alpine.LFD.2.00.1103082215300.2787@localhost6.localdomain6> <71ed11a4-aff7-4eb6-b037-0e097bb96444@email.android.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, H. Peter Anvin wrote:

> You said MSI-X has replaced MSI, which is true of course but doesn't
> change older devices in the field.

I know, but not for the price of nested loops over nr of cpus with
locks held and interrupts disabled implemented with a metric sh*tload
of horrible code.

Thanks,

	tglx
