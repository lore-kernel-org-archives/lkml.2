Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab2ILMej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:34:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54934 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2ILMei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:34:38 -0400
Date: Wed, 12 Sep 2012 13:38:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] block: add back command filter modification via
 sysfs
Message-ID: <20120912133849.6bec96be@pyramind.ukuu.org.uk>
In-Reply-To: <1347449133-26476-4-git-send-email-pbonzini@redhat.com>
References: <1347449133-26476-1-git-send-email-pbonzini@redhat.com>
	<1347449133-26476-4-git-send-email-pbonzini@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O
> +	if (!q->cmd_filter) {
> +		q->cmd_filter = kmalloc(sizeof(struct blk_cmd_filter),
> +					GFP_KERNEL);
> +		blk_set_cmd_filter_defaults(q->cmd_filter);

Out of memory - memset - oops
