Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0JRIMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:12:02 -0400
Received: from claw.goop.org ([74.207.240.146]:41303 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0JRIL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:11:59 -0400
Message-ID: <4CBC014D.7070302@goop.org>
Date: Mon, 18 Oct 2010 01:11:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the xen tree with the swiotlb-xen
 tree
References: <20101018155249.d9267bfe.sfr@canb.auug.org.au>
In-Reply-To: <20101018155249.d9267bfe.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/17/2010 09:52 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the xen tree got conplex conflicts in
> drivers/xen/events.c between several commits from the swiotlb-xen tree
> and several commits from the xen tree.
>
> I am unqualified to fix this mess, sorry.  I am dropping the xen tree
> for today (and only not dropping the swiotlb-xen tree because that would
> be too much work).

Argh, sorry, I should have coordinated with Konrad.  I'd merged my tree
into linux-next to make sure it was OK, but I guess I overlooked something.

> I wonder, of course, why I have seen nothing in either of these trees
> until today (less than a week before the merge window opens).

I had found Xen regressions that had made it into linux-next and wanted
to sort those out before adding anything else to the mix.

> Please sort this mess out.  I will drop the swiotlb-xen tree as well
> tomorrow if nothing has changed.

Will do.

Thanks,
    J

