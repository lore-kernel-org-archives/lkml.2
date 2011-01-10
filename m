Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1AJQZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:25:03 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:37192 "EHLO
	smtp2.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1AJQY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:24:59 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 smtp2.sgsi.ucl.ac.be B26FDEDF96
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?iso-8859-1?q?Universit=E9_Catholique_de?= Louvain
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
Date: Mon, 10 Jan 2011 17:24:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.5; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be> <201101101244.24932.christoph.paasch@uclouvain.be> <20110110075032.e38955ef.rdunlap@xenotime.net>
In-Reply-To: <20110110075032.e38955ef.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101101724.46023.christoph.paasch@uclouvain.be>
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: B26FDEDF96.00000
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday, January 10, 2011 wrote Randy Dunlap:
> Documentation/SubmitChecklist, #1:
> 
> 1: If you use a facility then #include the file that defines/declares
>    that facility.  Don't depend on other header files pulling in ones
>    that you use.
Ok, great. That was the answer I was looking for.

So, there is a clear rule that defines the #include-policy.

Now, should the missing #include's be added, or not?

Alexey Dobriyan is against it, as he says in one of his previous mails.
And, I'm nearly sure that the rule is not respected in plenty of other files 
of the Linux Kernel.

Cheers,
Christoph

--
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://inl.info.ucl.ac.be/mptcp
Université Catholique de Louvain

www.rollerbulls.be
--
