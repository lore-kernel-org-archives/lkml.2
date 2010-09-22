Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0IVWkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:40:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47796 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0IVWkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:40:35 -0400
Message-ID: <4C9A85A3.4020903@zytor.com>
Date: Wed, 22 Sep 2010 15:39:31 -0700
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
References: <20100922201547.3197.33702.stgit@bob.kio> <201009221552.21896.bjorn.helgaas@hp.com> <4C9A7EDC.5030809@zytor.com> <201009221637.18151.bjorn.helgaas@hp.com>
In-Reply-To: <201009221637.18151.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 03:37 PM, Bjorn Helgaas wrote:
> 
> That actually raises another question I had: we currently look at the
> HPET table pretty early, but I don't know whether the earliness is a
> requirement.  It would be cleaner if we could ignore the table and
> discover the HPET later in normal ways like pnp_register_driver() and
> pci_register_driver().  Then I could imagine someday dealing with the
> resources in a more generic way, i.e., in the PCI and PNP cores.
> 

Well, depends on how early we need timers...
	
	-hpa

