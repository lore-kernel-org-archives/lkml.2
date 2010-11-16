Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0KPPNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:13:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36497 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab0KPPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:13:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Nov 2010 16:11:54 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Remaining problems in firewire-net
Message-ID: <20101116161154.655470f5@stein>
In-Reply-To: <1289878275.16486.57.camel@maxim-laptop>
References: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
	<1289795401.11881.62.camel@maxim-laptop>
	<20101115090103.0df0b5ef@stein>
	<1289878275.16486.57.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16 Maxim Levitsky wrote:
> The IP over 1394 tells that unicast can also use ISO transactions.
> However, it doesn't say how to negotiate the ISO channel number, thus a
> logical conclusion is that its not possible to use ISO transactions for
> unicast.
> Is that right?

To my understanding, any unicast transport method other than block write
to the unicast FIFO are outside the scope of RFC 2734.  At the end of
section 7:
"""
   Unicast IP datagrams whose quality of service is best-effort SHALL be
   contained within the data payload of 1394 block write transactions [...]
"""
"""
   Unicast IP datagrams that require quality of service other than
   best-effort are beyond the scope of this standard.
"""
-- 
Stefan Richter
-=====-==-=- =-== =----
http://arcgraph.de/sr/
