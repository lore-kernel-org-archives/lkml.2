Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2FKIhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:37:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57237 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2FKIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:37:30 -0400
Date: Mon, 11 Jun 2012 10:37:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Fw: Re: [PATCH] x86, acpi/irq: Minor readability cleanup of
 gsi_to_irq()]
Message-ID: <20120611083725.GG31556@gmail.com>
References: <20120611074434.GA3383@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611074434.GA3383@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> Hi Ingo,
> 
> This patch probably get lost.
> Should I repost?

Yeah, please do.

Btw., it was not missed but is the regular workflow: when 
there's review feedback and it's resolved via a Reviewed-by 
somewhere inside the discussion then you should resend the same 
patch but with the Reviewed-by tag added. (and all reviewers and 
affected maintainers Cc:-ed.)

Thanks,

	Ingo
