Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab2FKIzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:55:20 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2613 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab2FKIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:55:18 -0400
Message-ID: <1339404917.30984.82.camel@x61.thuisdomein>
Subject: Re: [PATCH] Remove lib/mpi/generic_mpi-asm-defs.h
From: Paul Bolle <pebolle@tiscali.nl>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 Jun 2012 10:55:17 +0200
In-Reply-To: <CALLzPKak-GLPehY84_h-wURdrfnOW1nNeML_hpwdJi7mf-XkcQ@mail.gmail.com>
References: <1339169631.30984.2.camel@x61.thuisdomein>
	 <CALLzPKak-GLPehY84_h-wURdrfnOW1nNeML_hpwdJi7mf-XkcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 11 Jun 2012 08:55:17.0661 (UTC) FILETIME=[EC8524D0:01CD47AF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Mon, 2012-06-11 at 11:27 +0300, Kasatkin, Dmitry wrote:
> That patch has been already reverted and unused code removed.
> Changes are available in the #next-queue branch of Linux security tree.

That would be commit 9e235dcaf4f63d88a7e9ce5735ba5c2eb2719603 ("Revert
"crypto: GnuPG based MPI lib - additional sources (part 4)""). I'll
remove this header from the stack of (possibly) unused headers.

Thanks!


Paul Bolle

