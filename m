Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1BSGC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 01:02:29 -0500
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:20000 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750849Ab1BSGC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 01:02:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Organization:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=zFshqMxb/m/G/FhIgf6JXvU0eref9RenfXN+qk02tjZugHOvbBDEN5FpnMqDGnw6t+xzEiC4vgQNxwT50wluM01235H69QjN3ra+DkLpamCb7ZWe3zCzqH+XtINVhhD6ODIXd5/tfnvAKQpiFWUhRrium/9SF1d40pYU687rQsc=  ;
Message-ID: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: FbspZdUVM1kDhPkvTCoIZLNQI6EXcAEpvcrWdvQ8P9RO102
 Jw4gX9wX1N20UdnbY4NQNVH1o7aB0GALtFDldZRCLiA7oQYYw4jdqwrGvGin
 WbDkXVNt_Z_4d9HLKH9iTksYXivoylPcu1l.vCbPtceSsK6.8fvKCoPi7trF
 lX2QuM4wmdCg76F8e6SbZRF8yechzUaFS_RTMXEKmjdfENRaZhv0O72NVrsl
 HlxW.RI3LIw6LahKC0iKCMa07ryuoavfAmQP5tGtpfuUQYhtKEJ43yGk-
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Cc: alsa-user@lists.sourceforge.net
Subject: [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Date: Sat, 19 Feb 2011 01:02:22 -0500
Organization: sh0n.net
User-Agent: KMail/4.6 beta4 (Linux/2.6.38-0.rc4.git0.2.fc15.x86_64; KDE/4.6.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, 

I've noticed some changes with ALSA recently, and when I use my Conexant CX20561 (Hermosa) microphone I get mixed results:

My current Fedora rawhide kernel is: 2.6.38-0.rc4.git0.2.fc15.x86_64. I certainly will be using -rc5 as soon as either it 
hits rawhide rpm factory or rawhide mirrors.

... its in the factory .. 2.6.38-0.rc5.git1.1.fc15

1) Plug in headset, microphone works (using microphone headset)

2) Disconnect headset from microphone jack and external microphone on laptop shows barely any sound being picked up.

Laptop info:

Manufacturer:      LENOVO
Product Name:      4058CTO
Product Version:   ThinkPad W500

Driver version:     1.0.23
Library version:    1.0.24
Utilities version:  1.0.24.1


If someone from ALSA is on this list, I can provide you the alsa-info data. Maybe a quirk is needed.

Thanks,
Shawn.
