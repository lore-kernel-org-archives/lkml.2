Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1AJLoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:44:54 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:59807 "EHLO
	smtp4.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1AJLov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:44:51 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 smtp4.sgsi.ucl.ac.be D1274F28F8
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?iso-8859-1?q?Universit=E9_Catholique_de?= Louvain
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
Date: Mon, 10 Jan 2011 12:44:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.5; x86_64; ; )
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be> <1294614389.2823.35.camel@localhost> <AANLkTik7mug7j=VLz80DX_hJokeO3=ie+KRcMViSL4kB@mail.gmail.com>
In-Reply-To: <AANLkTik7mug7j=VLz80DX_hJokeO3=ie+KRcMViSL4kB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101101244.24932.christoph.paasch@uclouvain.be>
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: D1274F28F8.00000
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday, January 10, 2011 wrote Alexey Dobriyan:
> >> linux/percpu_counter.h (needed for percpu_counter_sum_positive)
> > 
> > Yes.
> 
> Currently code compiles fine, so necessary headers are in place,
> so simply adding new headers doesn't help anything.

I totally agree with you.
However we need a consistent coding style.

Or we just include the minimum necessary headers (as originally proposed by 
me).
Or we include every header whose structs/functions are referenced.

In my opinion the current "mixed" state is not ok, because some includes are 
there because there *are* references (even if these includes could be omitted, 
e.g., linux/list.h).
Other includes (like linux/percpu_counter.h) are not there, because they are 
indirectly included by another header and thus the code compiles. Even if 
there are references.
And there are no rules/guidelines to identify the headers that should be 
included and those that should not.

Regards,
Christoph

--
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://inl.info.ucl.ac.be/mptcp
Université Catholique de Louvain

www.rollerbulls.be
--
