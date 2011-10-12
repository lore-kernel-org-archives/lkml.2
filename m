Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1JLSTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:19:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33123 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1JLSTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:19:32 -0400
Message-ID: <4E95D9E7.6090304@zytor.com>
Date: Wed, 12 Oct 2011 11:18:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab>
In-Reply-To: <20111012101615.GA14966@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 03:16 AM, Borislav Petkov wrote:
> 
> Why would a xen microcode solution would even be contingent on how
> upstream Linux solves it (and when)?
> 

Agreed... especially since Xen is "special" when it comes to booting anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

