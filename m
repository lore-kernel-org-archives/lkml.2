Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2GWQ3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:29:34 -0400
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:60458 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257Ab2GWQ3d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:29:33 -0400
X-Greylist: delayed 1548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2012 12:29:33 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH] add blockconsole version 1.1
Date: Mon, 23 Jul 2012 15:33:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-90.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
References: <20120424205946.GH20610@logfs.org> <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com> <20120712174633.GA7248@logfs.org>
In-Reply-To: <20120712174633.GA7248@logfs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207231533.16350.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 12 Jul 2012 18:46:34 Jörn Engel wrote:
> Console driver similar to netconsole, except it writes to a block
> device.  Can be useful in a setup where netconsole, for whatever
> reasons, is impractical.

Perhaps you need to add a word or two about limitations compared to netconsole 
in documentation because it is quite significant difference in reliability? I 
mean so it is not assumed it is analogous to netconsole but just a different 
underlying media. I don't know if someone would expect it, but better said 
than not. 

I second the notion that logging to partitions would be useful.

Also, and I haven't checked what the swap format is, if it could somehow be 
integrated together that could be useful.

Tvrtko
