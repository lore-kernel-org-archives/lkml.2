Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab2EUVCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:02:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56774 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab2EUVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120521181558.GA7829@phenom.dumpdata.com>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com>
 <20120521181558.GA7829@phenom.dumpdata.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Mon, 21 May 2012 23:02:26 +0200
Message-ID: <CAJ75kXbJXVW6dJDzG7zDuiu=6NnTybM3m97gW507-yzzsa7yoQ@mail.gmail.com>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: shli@fusionio.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xensource.com, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 21, 2012 at 8:15 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> So you are asking for 052b198 to be back-ported.
> I am OK with that but I think Shaohua needs to Ack that and
> ask Greg to put it on stable@kernel.org

Yes, since I didn't find the official process to propose an
already-in-tree commit to stable@
(http://kernel.org/doc/Documentation/stable_kernel_rules.txt), I was
just asking around, maybe to get Shaohua feedback.

I guess it meets the requirements to be integrated in stable; tested
on my side in 3.2.x and 3.3.x and fixing a precise issue.

Regards,

-- 
William
