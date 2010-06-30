Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0F3Qna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:43:30 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:35677 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754530Ab0F3Qn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:43:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 729298.59665.bm@omp132.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=mLG2ccs7k33SEfBAyQGLT4zOH+u9ESmzNn71gBCDwkO8hFhBBwJP0i9qyuYiDy/xrXrYoaaSWXQ3IjKi7a6CRwQ24kPF0pnBbG5y3tXWRJsu6iD6fKpaVGCX7THAuXKXPJ/XFzYvCvKfBsXgkzRUlIV6cA1NCSDKPGNu5rWjNIY=;
Message-ID: <533693.91394.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: XVVJ_U8VM1kTvZ.6_0kjmbaPvO.2VIWUqhk.xLl9BXUjRPs
 6JhrLIwhPBY7TGRDD4HoyuqdDAz45q3gzVwB2KlCFqUfEK8U8bye8BztuAor
 YGdnmpUctViImE7ho5BCeRrBHY_aJGg1k2ISp_ZWy1PSb4ur867LlpRd.nQI
 .70oDAvb0tMSYX9Y35Ss4HyeZipJpUoES14cyGlLooKs5rc1l1NXaehRBOgc
 XrqlaTwZS9POAvS9Sf21u.Dh56DaF7gV.fgjFzISNyHssvtHEigfeeYOiotA
 77z3U05Mhyn_OdpRt9tnPvVuFNGUUJ2yJ6seQVuHWFEJX_xCHenay
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Wed, 30 Jun 2010 09:37:43 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 2/2] gpio: introduce f71808e_gpio driver for F71808E Super I/O chip.
To: LKML <linux-kernel@vger.kernel.org>,
       Denis Turischev <denis@compulab.co.il>
In-Reply-To: <4C2B6E1F.80004@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My first reaction is that this whole chip, including
its GPIO support, would best live in drivers/mfd like
various other multi-function devices.

I'm trying to avoid cluttering drivers/gpio with fragments of chip support that don't stand on their own...


