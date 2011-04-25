Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1DYXSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:18:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54990 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1DYXS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type
         :content-transfer-encoding;
        b=XpB8AGjFul6ltNgv2hZBOKg0lw+jxrDp/Kiq59QLSeaE241n5U1BiK9R1sGIoJEh9O
         k+HLxoh9ybRD4tep4+ZqRQRU4oDcfeXilFqQGFvYkoF1905IOovCQZEteSn/1NSG8uK1
         DEJc6rtl/fDL2pAvb8mboUwR4D/OoQ9vZFWas=
Date: Mon, 25 Apr 2011 19:18:18 -0400 (EDT)
From: Anders Kaseorg <andersk@ksplice.com>
X-X-Sender: andersk@dr-wily.mit.edu
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, vdso: SHN_LORESERVE is an inclusive lower bound
In-Reply-To: <4DB5F17C.8040105@goop.org>
Message-ID: <alpine.DEB.2.02.1104251850430.26664@dr-wily.mit.edu>
References: <alpine.DEB.2.02.1104251020170.26664@dr-wily.mit.edu> <4DB5F17C.8040105@goop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Jeremy Fitzhardinge wrote:
> On 04/25/2011 07:28 AM, Anders Kaseorg wrote:
> > Test for >= SHN_LORESERVE instead of > SHN_LORESERVE.
> 
> Yep, seems reasonable.  Did this cause a problem, or is it just
> something you noticed?

I just noticed it (while writing “modpost: Update 64k section support for 
binutils 2.18.50”: http://thread.gmane.org/gmane.linux.kernel/1130613 ).

Anders
