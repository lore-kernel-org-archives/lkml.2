Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0LMVx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:53:29 -0500
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:39821 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757838Ab0LMVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:53:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=R18NE6k+enS/LJDTaw59IX+s3d6JJ7xm3mfahayq6+ejwSadGqsWbz/FsuoNB9VIFHiCUpiGsdp+AYyfhos8pGM+fqNf/A9xABMkDgrt3HsFmD/nzvR1V1xt/ieHhqf0KgwU1/EeyKL1kvxbq5tGbgAwoEh/aE7kRNkVzq4mUYk=;
Message-ID: <506287.35672.qm@web31807.mail.mud.yahoo.com>
X-YMail-OSG: wmFHiYoVM1l2SrOhA_PSe51ZH3ZdlLhxXwpXUh3CQERzWwE
 PdCUI0JzC.pHR9lDCOzrXXV60493CFNq1FZbvBb4WgPHM1QJGNtvnrDdj_ip
 wr5gneikHq_cJioVlkuDh93r93qNoFgfvVwsSmW4Aa5VEBxrdvy1RgJahlu0
 BZH6go9H3rQU2ue2q81M4iZqVJzGW_ygrY.U4djM2RkxIBF5ykyTFVX2uU8r
 Z_WgQWd8USe_JtYOTgbuXnJ_rLELnE2g9qF5Jd56rrTWsOoJnmrWeKJ.Q3ve
 TeWryqNYZ4VXJsSbKF1ENsHvRFzJkik7i8.yKNnzmEcy0zy.hpP7GZwVPGNr
 Qgtyc.epjKmaaigak40gZ_aajXV6Z08qazbTtHLcWbWgAFvgEBmdxp.uDC41
 ZXr3JLLt59Rak
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Mon, 13 Dec 2010 13:53:22 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Mark Brown <broonie@sirena.org.uk>, Matthias Schniedermeyer <ms@citd.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20101213194841.GA20997@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/13/10, Matthias Schniedermeyer <ms@citd.de> wrote:

> As a future user of UASP (The protocol) i'm happy to spend
> a few more 
> weeks with UMS if it means the driver for UASP is really
> ready for 
> transferring TBs of data when released.
> (Altough i'm guessing that i will spend some more time with
> UMS anyway, 
> as neither the packaging nor the website for my USB 3.0
> enclosures 
> mention UASP)

Yes, it is ready. If you have a UAS device, give it a try. The uasp.c driver is in the free-linux branch off of master in my github repo. See the announcement here:

http://marc.info/?l=linux-scsi&m=129227488508299&w=2

    Luben

