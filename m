Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0JVEXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:23:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab0JVEXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:23:53 -0400
MIME-Version: 1.0
In-Reply-To: <1287719462.2198.37.camel@pasglop>
References: <1287719462.2198.37.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Oct 2010 21:23:30 -0700
Message-ID: <AANLkTi=F1vW4ou47oHJq1DBAHkRMcQMdaUsUMknvXAyr@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 8:51 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Here's powerpc's batch for this merge window.

Ok. Please double-check that I fixed up the merge conflict (due to the
irq_work changes) correctly.

                          Linus
