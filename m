Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1AGRQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:16:01 -0500
Received: from nm19-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.212]:24948 "HELO
	nm19-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754843Ab1AGRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:16:00 -0500
X-Yahoo-Newman-Id: 242497.73198.bm@omp1014.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.ca;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=R8Q47Jq1bv617p1uo2tb9vO0KH0dIvMDe8bS/GNvSEUqK4dzyIYoocA7zGlLWyllOCpWGGWpTXrpJtjYeq8juqVV6Kg5ASMK8bPLmf+T3nMMkY2ippPtDoKSmTBH2AluppyjvXkY8jnbiNPn2QFJd0hVqionACSehcbjc4WSxmU=  ;
X-Yahoo-SMTP: izt95ZKswBDBT1bN16dPvD5jLHMKn5IFkJA-
X-YMail-OSG: 2FaEHl0VM1kywztn7Pgp2lW5TkGBivicJo5243B6dUHwYuF
 mT0h40fUy5B7fTufdrB6GW9xOy9b.ASRc7sWuJ7_icVzSWWNNckUHRBuqC6d
 dIAv2BDDfkn5Q2gO1jJN5FOMAzOWKrDTuE_m6MO111BhCj8AcS0HmmyUul9T
 EB.dr8lOGqPceSUWkrirFYQEp2jcGGUWVeoowagO9j1XSL7hYOUwAACW3LYx
 SJBbGmSbkXcR7EQCYnoh_zxwCRIjVpiseBZlTqT0Bu3QIWhDnzsW4GG8Gg4x
 OgvrO0hALt.zuXF6bnQE6HKl6oUcWHqB_qkGzPMPsGexH
X-Yahoo-Newman-Property: ymail-3
Subject: Re: can't resume from ACPI S3 with TICK_ONESHOT
From: "James C. Georgas" <james.georgas@yahoo.ca>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
In-Reply-To: <20110107111658.GE16507@aftab>
References: <1294191939.3889.49.camel@Tachyon>
	 <20110105120959.GB4927@kryptos.osrc.amd.com>
	 <1294242385.3650.38.camel@Tachyon>  <20110107111658.GE16507@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 10:15:50 -0700
Message-ID: <1294420550.17472.1.camel@Tachyon>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:16 +0100, Borislav Petkov wrote:
> On Wed, Jan 05, 2011 at 10:46:25AM -0500, James C. Georgas wrote:
> > Let me know if you need more.
> 
> Yeah, what does
> 
> xxd /sys/firmware/acpi/tables/HPET
> 
> say?
> 

Tachyon james # xxd /sys/firmware/acpi/tables/HPET
0000000: 4850 4554 3800 0000 012a 5054 4c54 4420  HPET8....*PTLTD 
0000010: 4850 4554 5442 4c20 0000 0406 204c 5450  HPETTBL .... LTP
0000020: 0100 0000 1082 5343 0000 0000 0000 d0fe  ......SC........
0000030: 0000 0000 0080 0000                      ........
Tachyon james # 


