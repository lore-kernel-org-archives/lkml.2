Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0LHN7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:59:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:37764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab0LHN7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:59:35 -0500
Message-ID: <4CFF8F31.4010507@kernel.org>
Date: Wed, 08 Dec 2010 14:59:13 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] speakup: fakekey.c: Fix error: macro "__this_cpu_write"
 requires 2 arguments, but only 1 given
References: <AANLkTim0-EY8z6_XYG9ZGc3RnK7v8Du4njygsH62Wc5M@mail.gmail.com>
In-Reply-To: <AANLkTim0-EY8z6_XYG9ZGc3RnK7v8Du4njygsH62Wc5M@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 13:59:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 02:38 PM, Sedat Dilek wrote:
> While building linux-next (next-20101208) I fell over this build failure.
> The attached patch is compile-tested-only.

Rolled into the original patch.  Thank you very much for catching it.

-- 
tejun
