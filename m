Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2LLIlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:41:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:16105 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2LLIlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:41:18 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d4-50c8432c6ce3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "=?utf-8?Q?'Marko_Kati=C4=87'?=" <dromede@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org,
        "=?utf-8?Q?'Marek_Va=C5=A1ut'?=" <marek.vasut@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000201cdd283$baf50160$30df0420$%han@samsung.com>
 <20121205093027.GK14363@n2100.arm.linux.org.uk>
 <CAHod+Gdb_LEnhx5cz9j=q9PyS4L=Yjxs303dHon9i-tgjJRtDA@mail.gmail.com>
 <20121205192141.GQ14363@n2100.arm.linux.org.uk>
 <000801cdd6ae$da095270$8e1bf750$%han@samsung.com>
In-reply-to: <000801cdd6ae$da095270$8e1bf750$%han@samsung.com>
Subject: Re: [PATCH v4] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
Date: Wed, 12 Dec 2012 17:41:16 +0900
Message-id: <000001cdd844$7326c9b0$59745d10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3THcjMF/gnibCeSkm2Ffzjs/CPrQDjcJ/gAGX/QTA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA10d5xMBBvs3Gltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MyTu9C/5zVsyc3c3UwPiOvYuRk0NCwERi/ZUpULaYxIV769m6
	GLk4hASWMUo0nz/LDFO09cwcRojEdEaJJ99/s4AkhARmM0nM3BoMYrMJqEl8+XIYbJKIgLnE
	vJmTmEAamAWWMEvs3tvKDNE9h0miacUtsLGcAnYSF1/vZAKxhQXiJB4cmsYGYrMIqEqsuLCF
	EcTmFbCVWDJtOyuELSjxY/I9oM0cQFPVJaZMyQUJMwtoSzx5d4EVJCwBFH70VxfiBiuJjr8r
	2CBKRCT2vXjHCDFdQOLb5EMsEOWyEpsOgF0mIbCKXaK9cRUrxMOSEgdX3GCZwCgxC8niWQiL
	ZyFZPAvJhgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxQuJKagfjygaLQ4wCHIxKPLwN
	744HCLEmlhVX5h5ilOBgVhLhrTU8ESDEm5JYWZValB9fVJqTWnyI0Qfo8InMUqLJ+cCYzyuJ
	NzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBUVp1y8WcF0KdAo0L
	JL7XuJnL5N9/GmIbrFkkfoXPoEJtJqPQ2rO7v1a/TN3u9fbvsx3zZ9acmH+y6teqCh8XkZgA
	Tfcd+2tXJre0z+cvVTAVWp91RyB3n6SgwOTIbfknfrRb84mm+a4Osdzx9u+y+CytFca//idO
	/scY8fnwvpUlDo7nttQaKLEUZyQaajEXFScCACg2GNjYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQV0d5xMBBg9n61pc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMk7vQv+c1bMnN3N1MD4
	jr2LkZNDQsBEYuuZOYwQtpjEhXvr2boYuTiEBKYzSjz5/psFJCEkMJtJYubWYBCbTUBN4suX
	w2DNIgLmEvNmTmICaWAWWMIssXtvKzNE9xwmiaYVt5hBqjgF7CQuvt7JBGILC8RJPDg0jQ3E
	ZhFQlVhxYQvYal4BW4kl07azQtiCEj8m3wPazAE0VV1iypRckDCzgLbEk3cXWEHCEkDhR391
	IW6wkuj4u4INokREYt+Ld4wTGIVmIRk0C2HQLCSDZiHpWMDIsopRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOGqfSe1gXNlgcYhRgINRiYe34d3xACHWxLLiytxDjBIczEoivLWGJwKEeFMS
	K6tSi/Lji0pzUosPMfoAvTmRWUo0OR+YUPJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQn
	lqRmp6YWpBbBjGPi4JRqYPTj3pwjc+71p2+vqz43v7aNPuaTI/NV7ScTi+ad2Sp7nu56PO28
	KYfS230K4mYfdc4wrW4u/LtaeEKETsaiyydnVEg4nBZuYNcMUVs/48GEJ9uOz+uq+/fyeZ5t
	ynIDvbQbUur7dJ73pPBKrH1yz/pV5N3f0dPfpaZUt3cpxbb/mNnwLnPimSglluKMREMt5qLi
	RAA/2cgHBwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 5:18 PM, Jingoo Han wrote
> On Thursday, December 06, 2012 4:22 AM, Russell King - ARM Linux wrote
> > On Wed, Dec 05, 2012 at 07:20:00PM +0100, Marko Katić wrote:
> > > On Wed, Dec 5, 2012 at 10:30 AM, Russell King - ARM Linux
> > > <linux@arm.linux.org.uk> wrote:
> > > > On Wed, Dec 05, 2012 at 09:59:07AM +0900, Jingoo Han wrote:
...
> > Eric shares my opinion of the _cansleep() mess, but unfortunately it's
> > what we have and no one's come up with any better solutions to it.  (I
> > argued from the outset that the gpio_xxx_cansleep() should've been
> > gpio_xxx() and the non-cansleep() version should be called
> > gpio_xxx_atomic() so that by default people use the version which _can_
> > sleep, but have to think about it when they want to manipulate GPIOs in
> > non-task contexts.)
> 
> Hi Russell,
> 
> Thank you for your explanation. It is very helpful for getting hold of.
> I have been confused by the current function name such as gpio_xxx_cansleep().
> As you mentioned, gpio_xxx_cansleep()and gpio_xxx_atomic() would be better.

Oh, sorry. There is a mistake.

It should be as below:
'gpio_xxx()and gpio_xxx_atomic() would be better'.


Best regards,
Jingoo Han



