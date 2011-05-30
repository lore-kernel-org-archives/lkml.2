Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1E3Kxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:53:54 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:58597 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577Ab1E3Kxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:53:53 -0400
X-AuditID: 12074425-b7b78ae000007e02-d4-4de3772f1dca
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110530104656.GA19532@elte.hu>
Date: Mon, 30 May 2011 06:53:47 -0400
Cc: David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsUixCmqrKtf/tjX4FEri8XElZOZLS7vmsNm
	seVSM6vFjw2PWR1YPG61/WH22LxCy2PTqk42j8+b5AJYorhsUlJzMstSi/TtErgynu3wKTjM
	WLF0wmLmBsbZjF2MnBwSAiYS+3c8YoawxSQu3FvP1sXIxSEksI9R4vWjF8wQzgZGiZOr/zJC
	OKeZJHZ9+8QK0iIs4CExf9JRJhCbV8BQYummdnYQm1lAS+LGv5dgcTYBJYk7n/azdDFycHAK
	6ErMucgHEmYRUJVoWriSEaI8QeL4uS9sELa8xPa3c5ghRlpJrGq4AFYjJHCcUWLRTA0QWwSo
	Zs+xL6wgIyUEZCWalmVMYBScheSIWUiOmIVk6gJG5lWMsim5Vbq5iZk5xanJusXJiXl5qUW6
	Fnq5mSV6qSmlmxhBAc7uorqDccIhpUOMAhyMSjy8xkWPfIVYE8uKK3MPMUpyMCmJ8q4ueewr
	xJeUn1KZkVicEV9UmpNafIhRgoNZSYQ3MREox5uSWFmVWpQPk5LmYFES550vqe4rJJCeWJKa
	nZpakFoEk5Xh4FCS4NUrA2oULEpNT61Iy8wpQUgzcXCCDOcBGh4AUsNbXJCYW5yZDpE/xajL
	sWLN1oOMQix5+XmpUuK8sSBFAiBFGaV5cHNgiekVozjQW8K87iBVPMCkBjfpFdASJqAlve8e
	giwpSURISTUwOu71+WcnkFnxuf25sk/nkuszFM8ZfVXleJtneYqhJXi+X8TS8+efH3W5FWAp
	Vn1169ysyS/qlFT3N3RtnHfWymzzh8iIB0KME6/LL1N9b3xmd+eJ6p79LdKsYg0nZLhPWvSl
	blzaaJHHLtmztdvWJbNwn8hdjvMC9gtVvUJrC3mcVh3ou8igxFKckWioxVxUnAgAiWmh+CcD
	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd think that "make ARCH=x86_64 oldconfig"

... where the old configuration contained CONFIG_X86_32
should trigger a warning, if not an outright error that 
stops the build....

-- Ted

