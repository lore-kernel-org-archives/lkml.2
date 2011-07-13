Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1GMNSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:18:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64907 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1GMNSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <4E1D200C.9080509@kernel.org>
References: <cover.1310267866.git.luto@mit.edu> <2215c119e580b40f243c37d284e7bced309d975f.1310267866.git.luto@mit.edu>
 <20110711221432.GA10164@liondog.tnic> <CAObL_7ERJ4D_R5k1C7OHLz1etZzxcaTA7rzFmtRu0-gpq_YpMQ@mail.gmail.com>
 <20110712071832.GA17616@liondog.tnic> <CAObL_7F5KQA+GaSsU5nD+7gAY2JFv+XE0BRu+sRg0Mv24dBzaA@mail.gmail.com>
 <4E1D200C.9080509@kernel.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 13 Jul 2011 09:17:40 -0400
X-Google-Sender-Auth: fTcr_WWveDLAhmv2mgwg2zBdBa8
Message-ID: <CAObL_7FYHOvwdbu7jEraYdTSgFNEXEGiA2hkHQxXxM0jaGnSOA@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] x86-64: Improve vsyscall emulation CS and RIP handling
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 12:33 AM, H. Peter Anvin <hpa@kernel.org> wrote:
> On 07/12/2011 05:58 AM, Andrew Lutomirski wrote:
>>
>> Also, IRQ disabling was still mismatched in the sigsegv path.  I'll
>> fix that as well.
>>
>
> Just to make sure we're clear, we're still waiting for a new version of
> this patch, right?

Yes.  I'm testing it right now and then I'll email it out.

--Andy

>
>        -hpa
>
