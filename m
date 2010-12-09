Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0LICoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:44:07 -0500
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:28020 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932208Ab0LICoF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:44:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=TpiacjMKiz3NZYi0X5Cx4G4tHJ9gtGddXXBtfeOrFV0+46MUgABfUtFM8ug7CWpbk2i+Lv11a6fXcfXTFE7Gbwscn38546aa0F1QJ1d+hO6W8eSc1K1fFw615avYc0LWyLPTL3rGtFHTtV7rljB4JjW49au8KYCAdzzAbRx7sVw=;
Message-ID: <619119.14301.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: gUS1WwUVM1lhybD33APBZgtxiqatftF8zhRheQW51BMzloJ
 OimhtyWknQ9TQIJ86jihLvvUMiza9oEbEDR.SgjB3Zox.oBTnea1vTia0T_t
 k2gBsHwZXpxgGyuU4nJYQcT2ueQX0fgl3KdoFNlz8N_NiROEL3zx_hNwWYYl
 Kra520AJsoAP8IVy34dC8cCYDtjjxgp30G96Z2ghxgjpNLTLtLhN0FcHnCW4
 LrRXj3NomvdHUe4Mn19MxT8Hjgd.OTODzLxrtbS2bczlgWtn43kBWZHsUTIX
 MLWujqMcID0W4A7VtwlTYxH1MeUUjl2Bt7e6zaK4Wk1mKvs4LJ8Mz_pmiZbW
 NnOK0K7P_tGAfzZWp7xWq.7Ud2FWrbv7aJskuSHP3a0FloFMpx.IuxYBQoJw
 aAta0lkjiYEyU
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Wed, 8 Dec 2010 18:44:04 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: MEMSTICK: Add my 2 drivers
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1291862363.7792.28.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Since I don't touch (and don't want anymore to) any code
> written by
> Alex, and I even added workarounds for bugs in his jmicron
> driver to the
> generic ms_block.c code (it tested and works on my both
> card readers),
> maybe even add these to 2.6.37?

This are worked around by the recent patches, are not they?



      
