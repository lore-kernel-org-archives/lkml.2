Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab0FUCks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:40:48 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:46532 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755521Ab0FUCkr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:40:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 969360.13067.bm@omp123.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=uF5H2Kb9DhNyux6DymrA7TD0EYns2okveNCHefadzwWuJ183BJ8G6aPOXm2gmbSJEuLuhi0xwH/uD6RZPg3ko/ShsELVIGXeI02jKnnSPjVS/f29TcqxQKr29g2xbZrMwUWYZ3+Wt6EbiRlg3H0LJJ8bOdsMibNzLfK+97Wa0S8=;
Message-ID: <887171.45295.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: ZvLYD9sVM1kbKyIGAd7jxr6nWtKZF3_Pwlzs9AbsGxoibDU
 g04HukmWPOlJWSzqPu4YoVKp_pr8M8fhGc8eCAOdZA5wdbSs1kv1.dlwGiLD
 IwgSS.o2O0vvClavoaL7fO22_uPir1fZEXmK4kcOCbzgIhurIziYaEl66DDZ
 ubpEsKVRh1AlJOUT4Kbiww5XB_1ndU0xT0wQjQt._N9iyPEs.XwbLUpCHdfE
 RduFEpt9M701GtTQ7zqWrNNpB6y7XsFjHHLq9Ab1McqbOCpC8AP68Y.9.GxD
 GU8hpSjUdLPExz7No6GSBKyIpjMxdaHT5P28i3TJsimiRMIexOjjAZT7C0kr
 SDwH7Z_m8.HRC.D.pjrMDTlvWpTcEYWnDInI-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Sun, 20 Jun 2010 19:40:46 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: gpiolib and sleeping gpios
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4C1E88AE.5070808@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sun, 6/20/10, Ryan Mallon <ryan@bluewatersys.com> wrote:


> >> The point I was trying to make is that
> >> there are lots of drivers which
> >> will not work with gpios on sleeping io expandersbecause they call the
> >> spinlock safe gpio calls.

"Lots"?  You mean there are lots of
maintainers who aren't even bothering to
provide trivial fixes for bug which are
clearly reported to them by warnings?
These one-liner fixes are not hard...

Such problems are people-problems, not issues
with any framework. 
> > 
> > And they will trigger runtime warnings, and
> > thus eventually get fixed.
> \
>   }
> 
>   err = gpio_request(some_gpio, "some_gpio",
>           GPIOF_NO_SLEEP);


NAK ... keep it simple.  Such flags are
clearly not necessary...

I understand that some folk are bothered
by concepts/frameworks that seem "too simple"
and thus want to complexify them.  In this
case I am in a position to help avoid that.
Complexity is not a virtue.


