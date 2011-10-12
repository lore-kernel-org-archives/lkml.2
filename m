Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1JLKEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:04:37 -0400
Received: from ixqw-mail-out.ixiacom.com ([74.217.148.5]:22207 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750961Ab1JLKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:04:35 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 06:04:35 EDT
Subject: Re: [PATCH] dev: use ifindex hash for dev_seq_ops
From: Mihai Maruseac <mmaruseac@ixiacom.com>
To: Mihai Maruseac <mihai.maruseac@gmail.com>
CC: <dbaluta@ixiacom.com>, <mmaruseac@ixiacom.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>,
        "therbert@google.com" <therbert@google.com>,
        "jpirko@redhat.com" <jpirko@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1318413446-22258-1-git-send-email-mmaruseac@ixiacom.com>
References: <1318000849-2531-1-git-send-email-mmaruseac@ixiacom.com>
	 <1318413446-22258-1-git-send-email-mmaruseac@ixiacom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 12:59:23 +0300
Message-ID: <1318413563.2231.1.camel@sirius>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 02:57 -0700, Mihai Maruseac wrote:
> Instead of using the dev->next chain and trying to resync at each call to
> dev_seq_start, use the ifindex, keeping the last index in seq->private field.

Please consider only my last patch email, the first one was missing
Signed-off-by line.

Thanks,
Mihai

