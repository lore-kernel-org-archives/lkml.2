Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1K1FQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:16:33 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46310 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab1K1FQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:16:31 -0500
X-Sasl-enc: esCDHklFYxnMQGRhiZr9G0J95eVTJwK7rRrGp/Ie1eXu 1322457390
Date: Mon, 28 Nov 2011 14:13:39 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20111128051339.GA9709@kroah.com>
References: <20111128151857.d4ce49d38ed4983f8ba4d68e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128151857.d4ce49d38ed4983f8ba4d68e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:18:57PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/iio/industrialio-core.c between commit aaa0b4f00729
> ("iio: iio_event_getfd -- fix ev_int build failure") from Linus' tree and
> commit f791cec85073 ("Subject: fix build breakage in
> drivers/staging/iio/industrialio-core.c") from the staging tree.
> 
> The former was a more extensive fix (and is upstream), so I used that.

Yes, that's fine, I'll handle the merge when 3.2-rc4 is out, thanks.

greg k-h
