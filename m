Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1HEUsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:48:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46844 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1HEUsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:48:39 -0400
Message-ID: <4E3C571C.1070903@zytor.com>
Date: Fri, 05 Aug 2011 13:48:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
In-Reply-To: <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 01:45 PM, Andrew Lutomirski wrote:
> 
> hpa: time is supported (as of 3.0) by the vdso, and very new glibc
> uses the vdso version.  We could add a native time implementation back
> to the vsyscall page without too much pain as a short-term fix, but
> that would be less than ideal.
> 

How new does glibc have to be?

How much of a pain would it be to make the legacy vs emulated vsyscall
page a config option?

	-hpa
