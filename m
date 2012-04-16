Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035Ab2DPFPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:15:43 -0400
Received: from nm10.bullet.mail.bf1.yahoo.com ([98.139.212.169]:43583 "HELO
	nm10.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750788Ab2DPFPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:15:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 219258.98495.bm@omp1033.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=fsDyq8JNdktcw3Ida5MFQjYrZiMODMpPK+WYFNDKMxFZ57a7mFYVJuWxPof4NrBbPJbYWhGeenD5siDzUEG8G3rt11zgt/iFyRIZ4x5nAnhkYd4CGTaoLapp66Znk74DKk+hr5NfbJKeMs8zzlULWRMgD1MN1YZNV8eZgkYaVro=;
X-YMail-OSG: oyzSIvEVM1lM9sH8c8B4csZ1xW27vlpN5yHY4HH4LKDGLnF
 beE_mkWG9U6ahtMxGyrPDD.LSAl0zgkUjvUh7MLtrbSpaS8tUe0p14gW0p0b
 fGWjFfqN1ZIBEQyqehIxCcEz7EZ0Rei4BgvQJwglP.i8dNeAyYKlFtrqnXsR
 cjGguSQGpjXBMrh5.M2MSqusa9HHtJ3UAic9W89fCtSp2OK1mZ4R9MKDyCnR
 bmclZSqrrp_HfievevkCWenjciV_x9sfB5bYzGdwPkjNmUPNaM9nbbohwUmK
 q1PmaUWOEhC0LXUyvLf8whqiazn22mrGxSIbdqJ2hv35dRoSLwBisBWiqoUX
 B7SxtMfgvKbnjHLWKkaFDDYrHcOkjPlgE2JGqw5LN1rTSk92dnChyCTueC_n
 btBQf8WzczkFYzkhv.Vvh29B5J.EPoJszYWzxds6pelZdMBpfWJDqW0KGzvP
 o6KZbui4CDxfX33qQx8_9rsj_l_nzkiv28u4wzXsNFEZBgq.TdFX0Q2EFWNn
 Owy16u__HdVeDhCI6YE85YIReVncGDIhtzCgQ7IV8orOuS5XEwKD.4WsiOip
 L5f8wLtfuQzCu4ilPoIjaki8d
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204150011.53556.rjw@sisk.pl> <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com> <201204152030.23148.rjw@sisk.pl>
Message-ID: <1334553341.70819.YahooMailNeo@web161806.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 22:15:41 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <201204152030.23148.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki

>
> Do you still have the kernel where all PCI devices worked correctly after system
> resume?

If you are talking about https://bugzilla.kernel.org/show_bug.cgi?id=35452,
I am not aware of such a kernel. That bug has existed for as long as I have
cared to test.

Testing the patch v4 soon.


Mikko

