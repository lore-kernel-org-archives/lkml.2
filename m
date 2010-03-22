Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0CVRgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:36:10 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:53232 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab0CVRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=H0AcB2nDfPSMgbdw/R6AZ7vzXgEht4/kGH2UD2KBe4oKTFI4SEi5UG/11F96LXnWPC
         lruZ2JJ2d9dlu+2xVv4dMNzwpAFs8EKkTQK6UJP1qOUyLy48kHRi/gwQFgug/BeMiEfM
         mV4zb4uIMZVut+D9MIioJmiW+o/HCic4x/D6w=
Message-ID: <4BA7AA92.5040400@gmail.com>
Date: Mon, 22 Mar 2010 10:36:18 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: forcedeth: cat /sys/class/net/eth0/carrier = Invalid argument
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've pushed my kernel from the latest HEAD to 2.6.31
and am still seeing:
cat /sys/class/net/eth0/carrier
cat: carrier: Invalid argument

with my other machine using sky2
the same results is:
cat /sys/class/net/eth0/carrier
0

is there anything on this? before I start
a bisect.(looking through bugzilla, I couldn't
see anything related).

Justin P. Mattock
