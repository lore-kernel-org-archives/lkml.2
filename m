Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1I0RCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1I0RCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:02:20 -0400
Message-ID: <4E82017C.3010304@redhat.com>
Date: Tue, 27 Sep 2011 20:01:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jon Mason <mason@myri.com>
CC: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [REGRESSION] e1000e failure triggered by "PCI: Remove MRRS modification
 from MPS setting code"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ed2888e906b567 (merged 3.1-rc6) causes a reproducible failure 
with my e1000e card here.  Starting a kvm guest (which mostly consists 
of shoving display updates over X over ssh, as far as the network is 
concerned) locks up the card hard.

The failure is easily reproducible, will gladly test patches.

-- 
error compiling committee.c: too many arguments to function

