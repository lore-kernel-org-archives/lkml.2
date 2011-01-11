Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1AKRcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:32:52 -0500
Received: from nm28.bullet.mail.sp2.yahoo.com ([98.139.91.98]:48115 "HELO
	nm28.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753368Ab1AKRcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:32:47 -0500
X-Yahoo-Newman-Id: 243746.47202.bm@omp1018.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.ca;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=L9I4DdqMUQ3plu5cfL9aScbs5mtl5B+4CFXlaDNF6j2wMjqPZTsNAykifhyFBzrbdf8NiC9qY2qksQwjMDPbm1b+GbfqEd2lzx3K9+UTSaXFbqLo3i49Sn7cqq7yTBTvtGeoGWHQn09SG38fG+gpQFNHiCF89grwq4VO0BVWL7E=  ;
X-Yahoo-SMTP: izt95ZKswBDBT1bN16dPvD5jLHMKn5IFkJA-
X-YMail-OSG: YwgdmFsVM1kaqQE.fvrwwpjZjpKry_.bVzFB_vdrD6R40rC
 mAXv4ft6fKBl6LmDt6lW2b2e4Gpu.FeBG3H.REob9bLS4.yoYvE.6WM1VqrH
 xQ0Xmz7MkvLtf.FpTTQHLLBzp4jGCWLutw8pBZNdrSbzQrOhVUskiu1Cx_Wb
 aFANG_UPZx7xEZTgHmYIEcPDSVuOx8dseV9LDCTONgLUN9v27A1ZQrZgkjOy
 qTC0Rxjz9I.pKOHjvswIlfQejtDOebx1zU0c.0ss6li3RZgegIsPfegGNqkI
 hxQGNKDjCizSjWq3Ce2ud7ShWsy_CJ4mk_4zbayS59N583U8-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: can't resume from ACPI S3 with TICK_ONESHOT
From: "James C. Georgas" <james.georgas@yahoo.ca>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
In-Reply-To: <20110111141359.GD17619@aftab>
References: <1294191939.3889.49.camel@Tachyon>
	 <20110105120959.GB4927@kryptos.osrc.amd.com>
	 <1294242385.3650.38.camel@Tachyon> <20110107111658.GE16507@aftab>
	 <1294420550.17472.1.camel@Tachyon>  <20110111141359.GD17619@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 10:32:30 -0700
Message-ID: <1294767150.4981.3.camel@Tachyon>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 15:13 +0100, Borislav Petkov wrote:
> Ok, I don't see anything irregular here. Can you try booting the
> original tickless (NO_HZ) configuration without the "nohpet" boot option
> and wait >= 5 mins after resume to see whether your machine comes to
> life afterall. The 5min means we want to wait until the 32-bit HPET
> counter overflows to see whether the timer gets programmed with an event
> in the past right after resume.
> 
> Thanks.
> 

Yeah, it woke up eventually. I went away for about half an hour, and
when I came back, the system was on again. Do you want a more accurate
measurement of the time it took?

James

