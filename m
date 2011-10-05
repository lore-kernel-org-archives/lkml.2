Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab1JEVUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:20:45 -0400
Received: from nm3.bullet.mail.sp2.yahoo.com ([98.139.91.73]:31976 "HELO
	nm3.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932307Ab1JEVUo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:20:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 742513.43602.bm@omp1039.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=esFDyHxlYhMSyf1CmQiSLI977PzjP4fOEaHyodYAQkA0mm5HdfgZocXdObAYV0yY7yuoKcd9wh3UnUWN3Wvo9hAlOaM2+J8/rw1yOzAlQFDw+vkoCTwAezmizPJ/iDmdgDEmiIV1xcM0yrxdJ1n7Mdg253MrJRf9Toilj8khJGI=;
X-YMail-OSG: FQWznKcVM1kckjRRsuHHdrOfJ3zsKgELIORtgkbNwc91STI
 Znpay4v0chOlLYSnMwgOZ.EgjnNbvoozWHbFjAsoMpWaG01zGyQmwj5jWc2h
 py.2thEHMl.Kxlmtiw0nuzrm7ZJ_AuiPkLWaHXAUqJy.FOe7uCT9yH99OaNM
 ohUdoR8etr2xh1Yw3YTg9jUHctWq6.39W.sTZxMHVe_dazqxafTAeF.uGX_A
 caMqEJwLOcLQIHQP1NnEe7jJ__RjJozTbkMK0c3oyg8zdOo8hXZg.0.Roc.f
 aNF71nhlAgFxzo5IHUWUTLV5BD6CvsoDu0QjAXMnCXhXrsCre2IgJum7FoqT
 keuYKm2KrJFDt7atReqYYnIKWU9pv84ebdVKIizs9w7asmpIMK8pvP.Us8tI
 DxX61Tg22hZk9DvPGnqnttND6MYqhL90kVVwL0fWNJhOuhQJRawVN31o0MLw
 R8jRSE7EGzql6Gg4qmVZu6Vxy
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com> <yun1uuslfhg.fsf@aiko.keithp.com> <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com> <yun4nznmbxk.fsf@aiko.keithp.com>
Message-ID: <1317849643.25371.YahooMailNeo@web130122.mail.mud.yahoo.com>
Date: Wed, 5 Oct 2011 14:20:43 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
To: Keith Packard <keithp@keithp.com>,
        "terraluna977@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <yun4nznmbxk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 
I code, therefore I am


----- Original Message -----
From: Keith Packard <keithp@keithp.com>
>> By 'disable', do you mean revert? If so, I would the like chance to submit a patch that adds a boot parameter 
>> for the driver to disable the backlight by default, e.g: i915_disable_bl. Once the issues are sorted, the
>> parameter could be removed.
>
>If your machine used to work (with 3.0) and does not work with 3.1-rc,
>then we need to fix the driver so that, with no configuration changes,
>your machine continues to work. Preventing regressions is our primary
>responsibility when changing the drivers.
The patch I sent in a previous message in this thread makes it work correctly.
If I added an explanation and a 'Signed-by' line, could someone pick it up?

> Does reverting Matthew's backlight patch fix a regression on your machine?
Yes, but I have no backlight control: the screen is too bright to look at comfortably.

