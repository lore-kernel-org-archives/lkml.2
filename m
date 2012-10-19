Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2JSIZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:25:53 -0400
Received: from multi.imgtec.com ([194.200.65.239]:42133 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2JSIZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:25:51 -0400
Message-ID: <50810E8C.5010806@imgtec.com>
Date: Fri, 19 Oct 2012 09:25:48 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RESEND PATCH 4/4] net: smc91x: use io{read,write}*_rep accessors
 instead of string functions
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com> <1350488704-3711-5-git-send-email-will.deacon@arm.com>
In-Reply-To: <1350488704-3711-5-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_10_19_09_25_49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/12 16:45, Will Deacon wrote:
> The {read,write}s{b,w,l} operations are not defined by all architectures
> and are being removed from the asm-generic/io.h interface.
> 
> This patch replaces the usage of these string functions in the default
> SMC accessors with io{read,write}{8,16,32}_rep calls instead, which are
> defined for all architectures.

Hi,

Should this patch (and the mmc one) precede patch 1?

Also there appear to be some other places that it's used (e.g.
smsc911x.c and smc911x.h). I guess these should be fixed up first too?

Cheers
James

