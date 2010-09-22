Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0IVWDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:03:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33470 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0IVWDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:03:15 -0400
Message-ID: <4C9A7CE4.2070406@zytor.com>
Date: Wed, 22 Sep 2010 15:02:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, Simon Arlott <simon@fire.lp0.eu>,
        x86@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, HPET: ignore any PCI BARs that match an HPET we
 already know about
References: <20100922201547.3197.33702.stgit@bob.kio> <4C9A6534.3060800@zytor.com> <4C9A6D83.6090301@zytor.com> <201009221552.21896.bjorn.helgaas@hp.com>
In-Reply-To: <201009221552.21896.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 02:52 PM, Bjorn Helgaas wrote:
> 
> It really doesn't look like Windows, and therefore BIOS writers,
> share your expectations about PCI BARs in E820 reserved areas.
> It's likely still *safe* to make them fixed resources, but we might
> be able to fix more issues if we knew how Windows avoids the problem.
> 

*Which Windows*!?  Each version of Windows works differently, with
different quirks and bugs, and the BIOS vendors only ever test the
currently shipping version (except sometimes on server boards.)

	-hpa
