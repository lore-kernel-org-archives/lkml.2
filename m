Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab2CUQ1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:27:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43757 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab2CUQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:27:29 -0400
Date: Wed, 21 Mar 2012 16:27:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Adrian McMenamin <lkmladrian@gmail.com>, viro@zeniv.linux.org.uk,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] VMUFAT filesystem [1/4]
Message-ID: <20120321162726.GA27778@sirena.org.uk>
References: <CAN628AFKSgd2nKY5Ga7JqhVWqAySRW8OpeLyykOwocn4K_a-qQ@mail.gmail.com>
 <20120321153317.GA30250@kroah.com>
 <CACwZE5RbGARjgNRuJuLquDY_THjspH20JMEbKqsZVwj4jJtFhw@mail.gmail.com>
 <CACwZE5TZdJoAUcB+BN2OB0UK0UajnuMPia0vgCZs8wM=3bNE7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACwZE5TZdJoAUcB+BN2OB0UK0UajnuMPia0vgCZs8wM=3bNE7Q@mail.gmail.com>
X-Cookie: Steal this tagline.  I did.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 12:24:19AM +0800, Adrian McMenamin wrote:

> I guess the complaint is that I didn't include this with each bit. So,
> apologies for that, I cut it up by hand to avoid a 1700 line single
> patch. But I won't post it this way again, obviously

Nope, there's some other issues (like the signoff being after the ---).
Check the document again, and compare your mail with other patches.
