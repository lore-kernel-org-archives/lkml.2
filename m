Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1GMExq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 00:53:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39844 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1GMExp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 00:53:45 -0400
Message-ID: <4E1D200C.9080509@kernel.org>
Date: Tue, 12 Jul 2011 21:33:16 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v2 1/8] x86-64: Improve vsyscall emulation CS and RIP
 handling
References: <cover.1310267866.git.luto@mit.edu> <2215c119e580b40f243c37d284e7bced309d975f.1310267866.git.luto@mit.edu> <20110711221432.GA10164@liondog.tnic> <CAObL_7ERJ4D_R5k1C7OHLz1etZzxcaTA7rzFmtRu0-gpq_YpMQ@mail.gmail.com> <20110712071832.GA17616@liondog.tnic> <CAObL_7F5KQA+GaSsU5nD+7gAY2JFv+XE0BRu+sRg0Mv24dBzaA@mail.gmail.com>
In-Reply-To: <CAObL_7F5KQA+GaSsU5nD+7gAY2JFv+XE0BRu+sRg0Mv24dBzaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 05:58 AM, Andrew Lutomirski wrote:
> 
> Also, IRQ disabling was still mismatched in the sigsegv path.  I'll
> fix that as well.
> 

Just to make sure we're clear, we're still waiting for a new version of
this patch, right?

	-hpa
