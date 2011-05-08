Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1EHSSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:18:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58508 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1EHSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=nU9crl4h7TfgQJHusKhyuM/9BLhAH2fx8jsizKubQLuTxNGtRnr6KU9eEejYE1oqz4
         dYYaULcyZVRa5vXACuHiwcOB5hlWKunemgLbthNDxknvheMY1J4Hpe4Ztn5Ov5soBV3e
         w7CDyB2CFv03EzmRAng5kTY92OePBocfL6NXs=
Message-ID: <4DC6DE72.1000505@gmail.com>
Date: Mon, 09 May 2011 02:18:26 +0800
From: microcai <microcaicai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110504 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Question] Where is the missing 384k? Please, I've searching for
 it years!
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's being too long since I got this question.
I have to ask, even with a chance that I am considered as spam, and be
banned by kernel.org, I have to ask.
Please CC me if any one is going to answer my questions, I'll be
appreciate if you solve my haze.

So, my question is really simple, where is the missing 384k RAM?

When I read the books about PC, or see the output of dmesg, I've always
told that, 640k-1M is reserved for BIOS, and should not be used.

1)
384k RAM is reserved because BIOS is there. But I've heard that BIOS is
really in a ROM, not in RAM. So, where is the RAM when CPU is addressing
the ROM? Does the ROM just override the RAM and makes the RAM completely
un-addressable? What if people just got 2MB RAM? 384k of 2MB RAM is a
lot of wast!

2)
Is there a way to unmap the ROM and get back the RAM? or remap the 384k
RAM to upper address? If there is , why don't the kernel use this and
get my RAM(which is money) back?

3)
If there is not way to unmap the ROM or remap the RAM, why do they wast
384k RAM there! Even if 4G RAM is common now, 2M RAM is common in the
old days. Why did they do that!


Please help me to erase the big big question mark in my hart, Thanks!


