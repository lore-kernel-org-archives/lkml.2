Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0IQO5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:57:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab0IQO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:57:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: Remaining BKL users, what to do
Date: Fri, 17 Sep 2010 16:56:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Jan Kara <jack@suse.cz>,
        codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Evgeniy Dushistov <dushistov@mail.ru>, Ingo Molnar <mingo@elte.hu>,
        netdev@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de> <201009171550.49282.arnd@arndb.de> <20100917140219.GA9454@infradead.org>
In-Reply-To: <20100917140219.GA9454@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171656.56615.arnd@arndb.de>
X-Provags-ID: V02:K0:pxF85joxMv4hJDeSCH2F60RWbqf3tqrKpZ1uOBNNffE
 7xf0TO4unq0NFaVVaQZ8+1yuECARHRrYSAMc4aCcftVaPh/kuj
 5d3Y3ciWuvuH4UmU5qGyQapClWNFGewVUYOPzXzjRVG3pXENxA
 AVj0DhhvTou5qkpXFdjXF7aikDxEutvqRVqyBGYtgv5b2vFAhU
 M+kyXY/XtEh8+NMm4nIng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 September 2010, Christoph Hellwig wrote:
> 
> Just add a per-sb mutex inside the filesystem.  Given that lock_super
> isn't used by the VFS anymore that's actually equivalent.

Ok, thanks for the hint. I'll fix that for isofs.

	Arnd
