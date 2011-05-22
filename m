Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1EVJBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 05:01:46 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:37019 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab1EVJBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 05:01:40 -0400
Date: Sun, 22 May 2011 10:59:56 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Message-ID: <20110522105956.3b7a9fa2@absol.kitzblitz>
In-Reply-To: <1306051680-2354-1-git-send-email-arend@broadcom.com>
References: <1306051680-2354-1-git-send-email-arend@broadcom.com>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* "Arend van Spriel" <arend@broadcom.com>:
> +/**
> + * crc8() - calculate a crc8 over the given input data
> + *
> + * @pdata:	pointer to data buffer.
> + * @nbytes:	number of bytes in data buffer.
> + * @crc:	previous returned crc8 value.
> + *
> + * The CRC8 is calculated using the polynomial given below.
> + *
> + * x^8 + x^7 +x^6 + x^4 + x^2 + 1
                 ^
Could you possibly add a space here ...

> +/*
> + * table for crc8 calculation based on following polynomial:
> + *	x^8 + x^7 +x^6 + x^4 + x^2 + 1
                   ^
           ... and here?

Best regards,
Nicolas Kaiser
