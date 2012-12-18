Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2LRHQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:16:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2LRHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:38 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d0-50d01854b759
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001cddc2f$a2b2e8a0$e818b9e0$%han@samsung.com>
 <1355759442.13361.21.camel@joe-AO722>
In-reply-to: <1355759442.13361.21.camel@joe-AO722>
Subject: Re: PATCH] backlight: add lms501kf03 LCD driver
Date: Tue, 18 Dec 2012 16:16:36 +0900
Message-id: <005101cddcef$9dc65e10$d9531a30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3cbkZxCMunhc2RT7S4tyrBwwSrnQAgN3pA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zQ90QiQsBBv0bbSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGup7XzAU/+Sv23JZvYFzL08XIySEhYCJx610XC4QtJnHh3nq2
	LkYuDiGBZYwS26fPYupi5AAr2vLFGiK+iFHi5cwFrBDObCaJFeebwbrZBNQkvnw5zA5iiwgo
	SyxY9JkFpIhZYAmjxJyXnxhBEkICqRLblk1mArE5BYwkbva9YwWxhQUsJBY9XwQ2iEVAVWLf
	jVPMIDavgK3Ej42vmCBsQYkfk++B1TALaEls3tbECmHLS2xe85YZ4lJ1iUd/dSFuMJJYdqyb
	HaJERGLfi3eMEOMFJL5NPsQCUS4rsekAM8iZEgLL2CVenZrHDgkJSYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MUIiS2oH48oGi0OMAhyMSjy8
	QUnnA4RYE8uKK3MPMUpwMCuJ8N5eAxTiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGDU55XE
	Gxobm5iZmJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAGPjgQYKd4Z+lGh9/
	XLKxsjJ84PDp/pTvIZ6GJ0+HbO0PiT8qtXW32/0Kj4mO63cUz9dfrDSVIcyGP07o2LHF3nd/
	Ov4q6nqdINx8Y8ZVSxHFtu47C2I4nwZpXE7YYVCjyGh//5LcWS0zzlsrP8XWt9QYVtvK7Hrq
	2/BIu2i/deILDVmTpUXnlFiKMxINtZiLihMB8TLlr9kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd0QiQsBBv8eWFhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjHU9r5kLfvJX7Lkt38C4
	lqeLkYNDQsBEYssX6y5GTiBTTOLCvfVsXYxcHEICixglXs5cwArhzGaSWHG+mQWkik1ATeLL
	l8PsILaIgLLEgkWfWUCKmAWWMErMefmJESQhJJAqsW3ZZCYQm1PASOJm3ztWEFtYwEJi0fNF
	YINYBFQl9t04xQxi8wrYSvzY+IoJwhaU+DH5HlgNs4CWxOZtTawQtrzE5jVvmSGuVpd49FcX
	4gYjiWXHutkhSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIEx+0zqR2MKxssDjEKcDAq8fAGJZ0PEGJNLCuuzD3EKMHBrCTCe3sNUIg3JbGy
	KrUoP76oNCe1+BCjD9CjE5mlRJPzgSklryTe0NjEzMjSyMzCyMTcHIewkjhvs0dKgJBAemJJ
	anZqakFqEcw4Jg5OqQbGWo/wMu5th9WbcpI/Mp9iqLd/y7lhroit/7VpbSFVRby9LdsbDL98
	LS1R8YwyeLomP/fNjivdDpxstp+/y4TMTmr5MXVxr9rHDR3T8viN7LcsNEl+Ky3d1HFnZteH
	rFbhcpf5b+tifh1m65Fbz7p9ScA8S/ZHl/Y7R4jb/uJqWf82J3taGaMSS3FGoqEWc1FxIgA4
	K+YICAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 18, 2012 12:51 AM, Joe Perches wrote
> On Mon, 2012-12-17 at 17:22 +0900, Jingoo Han wrote:
> > Add the lms501kf03 LCD panel driver. The lms501kf03 LCD panel (800
> > x 480) driver uses 3-wired SPI inteface.
> 
> A trivial note:
> 
> > diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
> 
> []
> 
> > +static const unsigned short seq_rgb_gamma[] = {
> > +	0xc1, 0x01, 0x03, 0x07, 0x0f, 0x1a, 0x22, 0x2c, 0x33, 0x3c,
> > +	0x46, 0x4f, 0x58, 0x60, 0x69, 0x71, 0x79, 0x82, 0x89, 0x92,
> > +	0x9a, 0xa1, 0xa9, 0xb1, 0xb9, 0xc1, 0xc9, 0xcf, 0xd6, 0xde,
> > +	0xe5, 0xec, 0xf3, 0xf9, 0xff, 0xdd, 0x39, 0x07, 0x1c, 0xcb,
> > +	0xab, 0x5f, 0x49, 0x80, 0x03, 0x07, 0x0f, 0x19, 0x20, 0x2a,
> > +	0x31, 0x39, 0x42, 0x4b, 0x53, 0x5b, 0x63, 0x6b, 0x73, 0x7b,
> > +	0x83, 0x8a, 0x92, 0x9b, 0xa2, 0xaa, 0xb2, 0xba, 0xc2, 0xca,
> > +	0xd0, 0xd8, 0xe1, 0xe8, 0xf0, 0xf8, 0xff, 0xf7, 0xd8, 0xbe,
> > +	0xa7, 0x39, 0x40, 0x85, 0x8c, 0xc0, 0x04, 0x07, 0x0c, 0x17,
> > +	0x1c, 0x23, 0x2b, 0x34, 0x3b, 0x43, 0x4c, 0x54, 0x5b, 0x63,
> > +	0x6a, 0x73, 0x7a, 0x82, 0x8a, 0x91, 0x98, 0xa1, 0xa8, 0xb0,
> > +	0xb7, 0xc1, 0xc9, 0xcf, 0xd9, 0xe3, 0xea, 0xf4, 0xff, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	ENDDEF
> > +};
> 
> All of these ushort arrays could be uchar.
> 
> > +static int lms501kf03_spi_write(struct lms501kf03 *lcd, unsigned char address,
> > +				unsigned char command)
> > +{
> > +	int ret;
> > +
> > +	ret = lms501kf03_spi_write_byte(lcd, address, command);
> > +
> > +	return ret;
> > +}
> > +
> > +static int lms501kf03_panel_send_sequence(struct lms501kf03 *lcd,
> > +					const unsigned short *wbuf)
> > +{
> > +	int ret = 0, i = 0;
> > +
> > +	while (wbuf[i] != ENDDEF) {
> 
> Using an unsigned short where the high order byte
> is an end-of-buffer indicator is a bit space wasteful.
> 
> Perhaps a sized struct or array instead.

OK, I will use unsigned char, instead of unsigned short.

Thanks.




