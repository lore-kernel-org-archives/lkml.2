Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab0IVS7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:59:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab0IVS7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:59:03 -0400
Message-ID: <4C9A51DC.5020009@zytor.com>
Date: Wed, 22 Sep 2010 11:58:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221220.34066.bjorn.helgaas@hp.com> <4C9A4AAF.3030503@zytor.com> <201009221253.01049.bjorn.helgaas@hp.com>
In-Reply-To: <201009221253.01049.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 11:53 AM, Bjorn Helgaas wrote:
> 
> It's true, they don't (well, everything below 4G still lines up, but
> not above that).  Do you like this any better?
> 

That's fine with me.  I don't mind the [mem ] bracket either if you
think it's useful.

	-hpa
