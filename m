Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2FMOxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:53:38 -0400
Received: from nm1-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.202]:45458 "HELO
	nm1-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754149Ab2FMOxh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:53:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 388869.55466.bm@omp1064.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gBBDk3XsTEnLuopjT/XpQbvMIYe48AUob0pKr9S78ztVCSCvD1vJKUb4ZoyKSbLrdqxWnMXANjDzkcAKbx1aGU56rVq9W5k+eYeEMrMcHezE1L3GHFhAmQeA3SHtaldx9PH/c8BLlWBclO2HlEoQaWfGaATLNSZpJjBhK/tMaqY=;
X-YMail-OSG: lI0EIOgVM1lhur8_2F9x9Na1O5z_lyYmZrdluHDZS78zk4l
 6Tz3PAJs8Y4..IsSi3hIYOHHaTqVCvZJDj.PCG1p6tyqTq8OF9rLd9PCDTNA
 mNFcATGGpSYt8ChdjHxpxhrud0S1xh7q3_viH0BojXsy2aNOzzLFAn4H.Aoy
 1nol653zEJh_o5UQq9dF1oYOxz2Z8EF7dln1S_ZP4KdVlyUyidrCkaALu8w0
 cApM3o.k2KyG1DgeV41c89MWudHCksexjBBqFruDq1QmTrhUGaNBY_yDr4aS
 muvwkXhw38cuFjpZeHC5GgzCl_gW.M.2HMFr_Nd9Tq1KnDMpryExV246a.nH
 1DJR4pgk_XtIuI_xb7oqyJ3DavARhaavnN0DKDdEiM_2m4jUziFnUT_RLuy_
 bP3SDha7.rsMAZ61up2qeYYQFd7MCgkHoJCqbB2E_sJ7zi89tZnQYdgfU3lU
 OgIjNdiNqJhjWvzMgsJRXLK.uSpzq_YrVgdEUcLoqH_H8VF74oo3dQqkET7x
 99vU-
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com> <20120613133927.73c44f09@pyramind.ukuu.org.uk> <alpine.LRH.2.00.1206131552440.6369@twin.jikos.cz>
Message-ID: <1339599156.30833.YahooMailNeo@web111716.mail.gq1.yahoo.com>
Date: Wed, 13 Jun 2012 07:52:36 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: logging on kernel panic
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <alpine.LRH.2.00.1206131552440.6369@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@jiri:
>and you can get the dmesg+panic from there
 Sorry where? in the bios?

@Cong:
>The kernel log may not hit /var/log/syslog when kernel panics,
Can I ask why. Just before a panic, kernel is still alive and can log. 
Isn't that?


// Naderan *Mahmood;


----- Original Message -----
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mahmood Naderan <nt_mahmood@yahoo.com>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Wednesday, June 13, 2012 6:24 PM
Subject: Re: logging on kernel panic

On Wed, 13 Jun 2012, Alan Cox wrote:

> > Hi everybody
> > If a system receives kernel panic during boot, will it be logged somewhere?
> 
> Often not.. especially if it is fatal. Look up netconsole however.

Well your machine's BIOS can still be providing non-volatile sotrage which 
under recent kernels registers itself with 'pstore', and you can get the 
dmesg+panic from there then (provided you have all the necessary bits, 
such as APEI, compiled in and enabled).

-- 
Jiri Kosina
SUSE Labs

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

