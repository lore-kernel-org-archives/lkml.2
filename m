Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2FLUwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:52:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45747 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2FLUwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:52:38 -0400
Message-ID: <4FD7ABFE.6090801@zytor.com>
Date: Tue, 12 Jun 2012 13:52:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally
References: <1339533234-2265-1-git-send-email-andi@firstfloor.org> <20120612204917.GA26817@liondog.tnic>
In-Reply-To: <20120612204917.GA26817@liondog.tnic>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 01:49 PM, Borislav Petkov wrote:
> 
> What do we need that for? Mixed-ucode versions?
> 

Different CPUs in a multisocket system may have different compatible
ucode versions.  Of course, I am not even sure if it makes any sense at
all to compare microcode versions without qualifying them with F:M:S.

	-hpa

