Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0KYD7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 22:59:40 -0500
Received: from nm10.bullet.mail.ne1.yahoo.com ([98.138.90.73]:31425 "HELO
	nm10.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751713Ab0KYD7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 22:59:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 149002.32775.bm@omp1041.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=GK5OOKaaR+KD1yF8kMoeIAYgiGmx1pYVP2QID+9XeuwwuEexDWGNkLi+XH1treAPNrH2O2R9kMad/JJfs3Hs35o7rTqGXuO9dEOzKC/p40dqCKRwzuMBLASoGmGB1OFvj7JmAQ5gQTRf3RljSNROyY1iZKtEZFHCQ+luEAfGPro=;
Message-ID: <536589.12568.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: 7c6phvUVM1kBST1aNmCebWr6_bxvjH59GANrdqveYSd67KH
 Y.YoNg6caoZGI10OTb2Mfzo2tqFLLq7Kzxa8OfKVWGJK8HRlQnwhTViX.ZTr
 WpqvE9ZZyepurHmu83HsZQWqD5d2K8wnsEMMsuK0wnivSSWCemtWeSx4YMFP
 BUgJoraPwrFJcMKavoeykX5WM0DUiHTCobHhdD6hF4WraY6YpuJS5OWMqvZM
 _R.BGllb8J5l3zHSHK8TiDeJaQNfeOM9afFTdo9hHfEDlOfpAv9VrQAzdAZB
 mlToTdQKIBfKNlC5ZuCQaPx2XiRqGkjU5RUi9wnywb8rZYlOGeitSroACQPX
 lOuY47Q--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Wed, 24 Nov 2010 19:59:37 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: MugdhaKamoolkar <mugdha@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        BenoitCousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        HariKanigeri <h-kanigeri2@ti.com>, SumanAnna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My rule of thumb is that nothing is "generic"
until at least three whatever-it-is instances
plug in to it.  Sometimes this is called
the "Rule of Three".

Other than OMAP, what's providing hardware
spinlocks that plug into this framework?

- Dave

