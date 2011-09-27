Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1I0KQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:16:56 -0400
Received: from nm25-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.185]:21382 "HELO
	nm25-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753055Ab1I0KQz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:16:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 370417.89820.bm@omp1014.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2+H+M893zjqfSTsF/1604Oj1JYlNqpHzT4ImR5q/3HndDMny1CKGc0pX3DLslV4OrveISL1FRXK94OdYFrvUK2KbhdjfvFF2+8ltSMaqy738yRKZPMYef9En7VRHV8QUVxDh7C//DHVjwNtMxRCyT/Dh7/HYNI++4IQ9Di+rgsw=;
X-YMail-OSG: 5ykpN6MVM1njDZ1wUIyd2QcqdocefPoNkLABuXCmB9jRUG8
 DP66LIW4KLW0Y5fQXaDCwle0BQfbSF22wja_IxwA9aWD5RmyxHKTIikTl3T.
 9MmzN24T5VovHioVt7SXUvMNHEmwTZG_AzJfaFyDmLzsNXuHxwzQM4IIFNqL
 8ly2BtfZlWiSod3rCGJs6nli81QaeGHsE6yTyE8zWBcdhDJvdNmQy5JEhE5S
 61618e12DPTdGVdyBKQayxn8lhVfhHneEWxJ0IoAxebLl3vjjRqTWJYOpydi
 mC3ZNfGQoNLhkkwNUftOV.gUFbsRA3kaf1HxpVqsf7EhecSUNkKHU2m1i5Ah
 ikJFJJpuRgWuWIjIjAXZkdNhhy4jfEBF8ER7oZ8JKSn7hCDX_N.ZvuzqppO9
 PVZM3M2YpAgNPvP5sy2e109mpzDpWyWnXnCFHCXwDhD3g
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com> <yun39fkpdqf.fsf@aiko.keithp.com>
Message-ID: <1317118613.60118.YahooMailNeo@web130114.mail.mud.yahoo.com>
Date: Tue, 27 Sep 2011 03:16:53 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <yun39fkpdqf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At some point, Keith Packard asked:
>Are yo using the drm-intel-fixes branch there? That's the one with the
>FBC disable stuff.
PEBKAC. I must have booted another kernel. With your branch, I see the
password dialog when I manually adjust the brightness. It is no longer
necessary to switch to the text console.

>Alternatively, you can just disable FBC manually by adding the kernel
>argument:
>
>        i915.i915_enable_fbc=0
>

