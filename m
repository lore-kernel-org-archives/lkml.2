Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1KANcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:32:18 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:49785 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1KANcQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:32:16 -0400
X-AuditID: 1209190d-b7f726d0000008d1-b4-4eaff4dfe4b4
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <alpine.DEB.2.02.1110312158420.31794@asgard.lang.hm>
Date: Tue, 1 Nov 2011 09:32:12 -0400
Cc: Theodore Tso <tytso@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2947D9A5-4083-4B76-936A-DAA9508FE422@mit.edu>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com> <4EAF1FF6.3000500@zytor.com> <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com> <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm> <4EAF66C7.6080909@zytor.com> <alpine.DEB.2.02.1110312158420.31794@asgard.lang.hm>
To: david@lang.hm
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsUixG6nrnv/y3o/g1k7dSzmrF/DZtHWd4vV
	YtpGcYuN/RwWr/saWS2O7XjEZHF51xw2i0d9b9kdODzezLrI5jFt0ik2jx/PTrB7nJjxm8Xj
	8yY5jxMtX1gD2KK4bFJSczLLUov07RK4Mq7eZy9oZ6t4ePQ8cwPjHZYuRk4OCQETiZc71rJC
	2GISF+6tZ+ti5OIQEtjHKNE9ZSszhLOeUWLVvcVMEM4KJolnE2YxgbQIC3hLTPp1kw3E5hUw
	llhz6x3YWGYBPYkd13+BjWUTUJK482k/WJxTwFFi7/z/YL0sAioSB2f8ZYeof8QkcfyzBISt
	LbFs4WtmiJlWEleW3gWrERJ4yizxabcUiC0iICjx4fIGRoiz5SVavt5hm8AoOAvJGbOQnDEL
	ydgFjMyrGGVTcqt0cxMzc4pTk3WLkxPz8lKLdI30cjNL9FJTSjcxguKDU5J3B+O7g0qHGAU4
	GJV4eAMPrvMTYk0sK67MPcQoycGkJMr74vN6PyG+pPyUyozE4oz4otKc1OJDjBIczEoivP7L
	gMp5UxIrq1KL8mFS0hwsSuK8hTsc/IQE0hNLUrNTUwtSi2CyMhwcShK82sA0ICRYlJqeWpGW
	mVOCkGbi4AQZzgM0/DnIYt7igsTc4sx0iPwpRl2Ou42LTzEKseTl56VKifP+BCkSACnKKM2D
	mwNLa68YxYHeEubVBFnHA0yJcJNeAS1hAloy8xLYkpJEhJRUA6O4qrHirMmBdhsncUVO3xSX
	k75i9eEZlhv+cf6/yHNaJ3ivwccM68/XW/r2vb31J2ZKCZ+9m4OAaEaPdShPQOeaH/tjXi3x
	sTbO+Ppkn08ZR2oLb5/2naW5opsDZn1U8eBZNZOxzPzL492x296cnvkkwM6iraxnsW7lyh6t
	n7djfnXPtZV7ukqJpTgj0VCLuag4EQBSf4h1RgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2011, at 1:03 AM, david@lang.hm wrote:
> 
> my biggest gripe with most IMAP clients is that they try so hard to cache everything locally that you may as well just copy the mail locally to begin with…

I use a combination of mutt and mbsync (isync is the source forge project name), precisely because I want everything locally, so I can read/delete/reply to e-mail while I am off-line, but then be able to get back onto the network and sync everything back to the IMAP server.   I also like this better than copying the mail locally because if my laptop explodes or is stolen in Belgium, I still have a backup on the IMAP server.

One nice thing about mutt by the way is that it has very nice PGP/GPG integration…

-- Ted

