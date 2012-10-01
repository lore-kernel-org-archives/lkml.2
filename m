Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2JAXHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:07:05 -0400
Received: from nm23-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.224]:49063 "HELO
	nm23-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933347Ab2JAXG7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:06:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 789754.17894.bm@omp1070.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=c9e2TpvtGx7oEXrbSt8/gXuPeR6IhvFMlYUsy3NuYaqXuaug/eoFHFvhd6O6xNG9GAINcGVTTni2YOxLLf+rWGo8h/001JPhMisf5BZlX4GnxCDmQUaILHHHOFrciLz2FmHqgFFTdMZB0n0BaJGniNrpQRX/S1VZaHW4p4KBKs8=;
X-YMail-OSG: p2Xgj44VM1l42i7J9jKWqwWs9qg2EAhPQvLRWPCb8SeYQl4
 nm2tmW4KOjJM3MzCUu9M_W94TLq_bUQBa.fBaEEZucgbKjM8hWEBVTboF17R
 BvV8BoK45fLovUECrITD3iyyl.CrFlXWt159EZMYVUrkV0c94BVI72C90UUN
 A_MsE14ovoqMonZKH3YHtSBYkw3CpGdpWERsTs5vk7BSSjU2rDP1333Z0cbz
 dK71PGnGW9f8378JEs8TmGj64sWJtm3i563vz.UT0c5JfvNbVL8n4jvQlNz1
 LObIDw3fIGkrna9pwoqZ0NVWQBRHEYwJ96dyrHDVwsvhT6Bc0uRf5u8vBmnf
 qJpWS0WPllGR9v.S1cXifs.V01vfKejQIJrUvFCWgGC45K0Ji6FKzVhPqHb6
 6NEkzdD4rivw88Wx7jf3d._At3.jwGI0XlLVcQcmyFCka
X-Mailer: YahooMailWebService/0.8.122.442
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>  <20120928121917.GF5368@mwanda>  <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>  <20120929072527.GA13767@mwanda>  <1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com>  <20121001150913.GC13767@mwanda>  <1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com>  (sfid-20121001_184314_573998_F50474BE) <1349119899.10330.53.camel@jlt4.sipsolutions.net>
Message-ID: <1349132818.58475.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Mon, 1 Oct 2012 16:06:58 -0700 (PDT)
From: Kevin Cruz <skate_ops@yahoo.com>
Reply-To: Kevin Cruz <skate_ops@yahoo.com>
Subject: How do I get mac80211 debugfs?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Wireless <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1349119899.10330.53.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Johannes,
    None of this should be too much of an effort for me. Thankfully I
don't find terminals to be daunting.

> Yeah ... we saw this in the lab at some point, but somehow we couldn't
> reproduce it again later. The issue is that we stop the queues, and
> never restart them, and if it's the same issue then it's definitely the
> driver's fault.

> To confirm, when you get this, can you please do

> sudo cat /sys/kernel/debug/ieee80211/phy*/queues

> (assuming you have mac80211 debugfs compiled)

So I tried that but all I got back was:

    cat: /sys/kernel/debug/ieee80211/phy*/queues: No such file or directory

so I'm assuming it's because I must not have mac80211 debugfs.  So how
do I get it?

Thanks, Kevin

