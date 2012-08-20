Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2HTMi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:38:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47921 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2HTMiX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 20 Aug 2012 08:38:23 -0400
Message-Id: <50324BD902000078000966B7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 20 Aug 2012 13:38:17 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <ak@linux.intel.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <x86@kernel.org>,
        <akpm@linux-foundation.org>, <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight
 optimizations for LTO
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-47-git-send-email-andi@firstfloor.org>
 <5030B1A5020000780008A200@nat28.tlf.novell.com>
 <20120819151516.GS11413@one.firstfloor.org>
 <50323427020000780009660E@nat28.tlf.novell.com>
 <20120820111838.GC4461@tassilo.jf.intel.com>
In-Reply-To: <20120820111838.GC4461@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.08.12 at 13:18, Andi Kleen <ak@linux.intel.com> wrote:
>>  That's not the point: The point really is that you could allow the
>> alternative regardless of LTO, and just penalize the LTO case
>> by having even the asm clobber the registers that a function call
>> would not preserve.
> 
> That's just what a normal call does, right?

Exactly.

Jan

