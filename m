Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0IXSDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:03:42 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:44073 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755769Ab0IXSDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:03:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IAjyxnrgTk32AFVHuUZ/UotEw8oKITx7dChmruuQAqZcv9+UVZpsAGcNsex0BTpdC+6BxfwfJvvQ0sIojtaBuoQ8EYWql0WFb4Aw29Lt9jqpA5PrZTV/p2qn8yI46OtU;
Date: Fri, 24 Sep 2010 11:03:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/2] OLPC: Only enable PCI configuration type override
 on XO-1
Message-ID: <20100924110338.18c8fe83@jbarnes-desktop>
In-Reply-To: <20100923162805.0F6549D401B@zog.reactivated.net>
References: <20100923162805.0F6549D401B@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 17:28:04 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> This configuration type override is for XO-1 only and must not happen
> on XO-1.5.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
> 
> Replaces earlier patches:
> [PATCH 1/3] OLPC: extended board revision detection
> [PATCH 2/3] PCI: OLPC configuration cleanup
> 
> Due to the fact that CONFIG_OLPC is associated with multiple laptop models
> (not only the XO-1), it makes sense to keep this as a separate configuration
> option.
> 
> We decided against adding functions to distinguish between XO-1/XO-1.5 as
> we don't want to encourage laptop checking in this way. There should only be
> one or two cases where this actually matters (here is one of them).

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
