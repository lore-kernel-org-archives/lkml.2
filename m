Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0HZR5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:57:39 -0400
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:30648 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752260Ab0HZR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:57:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 584601.69740.bm@omp120.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=ZTa5BFALQXTx4W3R6YUllNk+ICckDxBxHN6fEWFYBglkxiOir/eH6fiUAMw3TTqMlnZ6HnzXWKlLGKIqOL9iF7f2fbZJO5PrmbsHAz1ueeY6NVDoQ2xRoUosD7t4B+U8AJ2c97D3mF6k2KuYeb+AcnvX9HA3bUrpdmWOWjE4Ht0=;
Message-ID: <488952.94429.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: IL.iY_0VM1l7qHt3xnwRSKtc5EiJwxcRER5YSlNRPlbzDKT
 iJLRZbMhNt_4HulIRrGThOBc.7.ljMrzETHkYpUQgxvdRE4dZY72X_Mu9236
 vCF2Bk0_6OssJdCf4jRwIQMQirRhFM6gNFWfmdIfWWHYpjKXprY7wp.z5FlZ
 8tSIDM.daRqnCz9EXymTIOWMerwdwVlWvGFLBp0A4CaI7DLtH9SjeSiMjZvr
 mbmp6vTjRjVanRwShPcdmqxGYE27W6sOc9bCrjI0mBbPme5fXY6g75FDF6ER
 mdt4ZfZqZ7ZSXAbKPzloQYDAiPZrz4uTSEgQOHsLn_Aksl5yW0Ilfdc12iP6
 E.4TgPqQUUuu3
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 26 Aug 2010 10:57:33 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] gpio: Add driver for Anton GPIO controllers
To: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20100826172602.GA20410@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 8/26/10, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>
> - Hopefully addressed David's comments
> regarding driver name;

I'm not sure about the precedent of putting
developer names in source.c and driver names...
start that, and everyone will want to follow!!

OK, so Linus started that one, arguably...  :)

Not that I want to be naming this, but how
about a tweak to Alan's suggestion, keeping
the name technical?

   "gpio_basic_mmio.c" ... or similar?

