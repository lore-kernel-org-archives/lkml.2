Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2DOKrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:47:11 -0400
Received: from nm24-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.161]:36163 "HELO
	nm24-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753340Ab2DOKrJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:47:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 111874.13332.bm@omp1060.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lsZdYdgfWaQcH2SqOaVViTu3MQtkuS11iVRfd6e4zmj6d6ELRuh+Vp+KcnPKps5qcqlNu10hJR7NtVTsKRlSnC27p2Xxxx9nK/54p8V9XkTtNW2GankukW1S2LzgzQefoKksLgjxnYj/ctLhp6OPvzzDcl+x1X6KfI7ME9tnD3M=;
X-YMail-OSG: ekZyIDMVM1ndhVxXcoF2wN2m186T31ZybNGBvmqjdYcK9jj
 6DbNEkEKh_GrFZ.uKy5BnU.1GD7mulB1Y1u84uJVdxurw.tjoZzk2N3D722C
 sHSAlc.2ywd.pRdTc1f72eIcDEOSM7fT0pJI7aHAgo_SVggEWFjF7JRfv.LV
 D5N4q9kW99LOODQ02_rDmCY61ymuqLqhgESVYkirSV_P8y7AZbHKmt2a6WvU
 yVx.XJ.5rvVYjmdh90eWx2hU2VjNn8xzKUDH2UZgpdXOLcicjoSGVLy07qsU
 yIb9sVZJC8Fi427yvGRWFsmLbxVhVsXWw7HBkJnWWZPCUMCh9.uV.J_soZZ0
 S6myQ_4V6lHXKu1a747M6aGl1Yh438wF6K4Uo0cjBPe5pkvR_I_vG8UJRIiI
 7iPJNLr.HLaqyyEOgbU25uxIH.AcfgIAtus22RA3Y.8SzqfPXmGm_BTsrkt4
 vQVZm_cSMza0M5Kaanmrumdl7hLwflR3fPaaj0..MLNib.9L9X0Ar0VPfAG6
 uDQelNZdUhPkjXhOHBhtpq8yEmMCW5ijZtxJh9.YbL77pywr0sirhxs.GgHH
 1eQYfphUfdDVeR3jXzOCDlFmK8dWC9OdUTVC5r3f03aqbiYxqQJpSMmMMTZ6
 m1Orm9jSAkd1NnHKHpJG4
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204132118.22074.rjw@sisk.pl> <1334346546.93033.YahooMailNeo@web161806.mail.bf1.yahoo.com> <201204132219.23106.rjw@sisk.pl> <1334350068.79333.YahooMailNeo@web161804.mail.bf1.yahoo.com> <CAAMvbhEFLHPsemALYVQwsuTaAiom1RviLECcPwqdtzA4ogmuLw@mail.gmail.com>
Message-ID: <1334486827.79192.YahooMailNeo@web161806.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 03:47:07 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <CAAMvbhEFLHPsemALYVQwsuTaAiom1RviLECcPwqdtzA4ogmuLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Courtier-Dutton:

> 
> On 13 April 2012 21:47, Mikko Vinni <mmvinni@yahoo.com> wrote:
>>        1 firewire_ohci 0000:0a:00.0: Refused to change power state, 
> currently in D3
>>       10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xf 
> (was 0xffffffff, writing 0x10a)
>>       10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xe 
> (was 0xffffffff, writing 0x0)
> <snip>
>>        1 sdhci-pci 0000:0a:00.1: Refused to change power state, currently in 
> D3
>>       10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xf (was 
> 0xffffffff, writing 0x10a)
>>       10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xe (was 
> 0xffffffff, writing 0x0)
> <snip>
> 
> Could the problem be more due to "Refused to change power state,
> currently in D3".
> the "was 0xffffffff" would be returned if their was no power to the 
> device.
> Don't you need power, before you can write to the config space?
>

Those messages and the problem of the combo card reader and firewire
not working after s2ram has been present for long
(https://bugzilla.kernel.org/show_bug.cgi?id=35452
dmesg here: https://lkml.org/lkml/2011/5/15/55).

Before 3.4-rc1 there was nothing wrong with the touchpad (and keyboard
and reboot) after s2ram, and the problems are somehow separate.
Rafael's patch fixes the new problem, any suggestions for the old
one would be warmly appreciated.


Mikko
