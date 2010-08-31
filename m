Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0HaUcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:32:11 -0400
Received: from n4.bullet.mail.gq1.yahoo.com ([67.195.9.84]:43457 "HELO
	n4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753602Ab0HaUcJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:32:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 30553.22862.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Orbog6ySMm3xnGpzs0C4riBCxceiz+xWAm6r6U6YtCdfumFgBjWG8hE+EvTR0XGBHqWe+CqShHRCX4LCmpZJJuDiCn2arTqHm7WAyCS9GrGuKIk8MBmba44fS899jg+wnn/I41X7+Ao7CBK/6i4MM6rAF0hI/mQlv4NRWoyDhJU=;
Message-ID: <755774.85376.qm@web180301.mail.gq1.yahoo.com>
X-YMail-OSG: tDIW5cwVM1nfdZffD2FMGViUG.l_Sbcf97NkyiBMDX2Q48G
 FAyUDf0NIdjWnVTlGyPQgbNlX5PaH.i_zMMfok.GAXSXaatbTiz08z.0qQaZ
 B4UG8_ZIKgXY9LzEDbDU9anCd0LTmCSpDHEIYibcrARGsFE.J5ZoNMAYydr0
 Gb95qiM_bSLtKABELoFVfUjg.DlPp5pKk8gFnGMe0GZzKEsFqwNb9.oMkhEk
 mP1NBuMvaVFxsDj3of8jXmovziqgQHy6MzKph6cy9yPOF5JR4qWYgDoEfbkR
 8.0CZD6jZKr5r.wImmXv8i38sAwSn8QieS48qJ.zZUGgOrFzDjPVHxM0Tlg-
 -
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Tue, 31 Aug 2010 13:32:08 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v5] gpio: Add driver for basic memory-mapped GPIO controllers
To: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20100831175839.GA32468@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> +static int bgpio_dir_in(struct gpio_chip *gc, unsigned int
> gpio)
> +{
> +    return 0;


Here -EINVAL is more correct there than 0 ...


