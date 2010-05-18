Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0ERMpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:45:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:58431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab0ERMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:45:16 -0400
Subject: Re: [PATCH v5] mtd: Do not corrupt backing device of device node 
 inode
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikvuNiLD-n9Qvf10NmMU2KFQ25YPfM1oYfXtHE9@mail.gmail.com>
References: <AANLkTimB1DsCd8HuMDc9jgVOnOAE_PVd2ktssp3TIwxc@mail.gmail.com>
	 <1274105441.6930.6920.camel@macbook.infradead.org>
	 <1274182023.6930.7023.camel@macbook.infradead.org>
	 <AANLkTikvuNiLD-n9Qvf10NmMU2KFQ25YPfM1oYfXtHE9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 13:45:06 +0100
Message-ID: <1274186706.6930.7213.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 15:18 +0300, Kirill A. Shutemov wrote:
> > http://git.infradead.org/mtd-2.6.git/commitdiff/cd874237
>
> Looks ok. Thank you.
> 
> What about stable@? 

Ah, yes. For future reference, we should have included an explicit
'Cc: stable@kernel.org' in the commit itself, rather than just in the
email thread. As it is, we'll probably need to wait for it to hit Linus'
tree and then submit a backport to -stable. It'll need a slight massage
to apply to older kernels anyway.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

