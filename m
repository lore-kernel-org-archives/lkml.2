Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2CSIEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:04:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:62645 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2CSIEk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Mon, 19 Mar 2012 04:04:40 -0400
Message-Id: <4F66F6A302000078000792FF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 19 Mar 2012 08:04:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Lasse Collin" <lasse.collin@tukaani.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xz: make use of BCJ filter also for 32-bit x86
 kernel
References: <4F621C930200007800078B9E@nat28.tlf.novell.com>
 <20120316204737.23aacd2b@tukaani.org>
In-Reply-To: <20120316204737.23aacd2b@tukaani.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.03.12 at 19:47, Lasse Collin <lasse.collin@tukaani.org> wrote:
> On 2012-03-15 Jan Beulich wrote:
>> The ARCH value for 32-bit x86 is not x86, but i?86.
> 
> Thanks for noticing this. Is ARCH even the correct variable to use?
> Maybe SRCARCH would be better. Then it would be enough to test for x86,
> if I understand the toplevel Makefile correctly.

Yes, that might be even better (albeit requiring adjustment of the script
should the naming in the source tree ever change again, whereas the
ARCH values are supposedly stable).

> On SPARC, it seems to be possible that ARCH is sparc32 or sparc64 while
> SRCARCH is always sparc, so currently xz_wrap.sh seems to be buggy on
> SPARC too.

Indeed.

Will you get a patch to Linus then to fix all of these in 3.4?

Jan

