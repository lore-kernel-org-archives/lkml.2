Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2JXRic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:38:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2JXRia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:38:30 -0400
Message-ID: <50882787.3030504@onlinehome.de>
Date: Wed, 24 Oct 2012 19:38:15 +0200
From: Martin <marogge@onlinehome.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org, tytso@mit.edu,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
References: <jXsTo-5lW-13@gated-at.bofh.it> <jXBDk-7vn-13@gated-at.bofh.it> <jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it> <jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it> <jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it> <jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it>
In-Reply-To: <jXWeJ-7Lk-1@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:JhGehN7A/U+GjBdMmZJP7SO5ncFCJp3rwmAOWCXs4in
 6QpGhKBk0N1fhCNPkPi9+ZVjU+/PDLCr2T0LRvkqR924wZLmtZ
 ZsFAIEOuEaq11X8caUwPi850WJGBpl05w8yO+3IXq7Tbc3b+ai
 f3jzzw7xksEuet85UueiCPvRzCQ6ALpFOyTwUYlbTyWAs5AmcU
 0ireDKHWuBFADDJlY/F67WpYEEfFyUrhYsMvOoseVZp3ARD8l4
 CNbXLNz5s/AUP7aK37De9n57t/Hk6l9IqYK08Jog4iEsQuc1+r
 zJHmo1HzJoxHnYgabWc6LehQEEfOGeJ1fL3DZqTnq9OoqVrQnR
 2PFu75x+z4WzwlQT0YR8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 01:40 AM, Nix wrote:

> It's true that in less than a week
> probably not all that many people have rebooted often enough to trip
> over this.
>
> I hope.
>

Fwiw, i got a fried root filesystem (ext4) on one machine last week. It 
was on 3.5.3 or 3.5.5. Since there was nothing in the logs and the 
kernel was modified (CK, BFQ) and tainted (nvidia) I did not notify any 
maintainers. I have not had the time yet to rebuild the machine 
(unfortunately that will be laboursome), so the users cannot do their 
homework or attend to their social life for the time being...

The pattern was indeed characterized by a sequence of reboots (I am 
told), and in a weird fashion files started to disappear from the root 
filesystem (I first noticed /etc/groups missing, and after further fscks 
and reboots login became impossible (I assume that /etc/passwd and or 
/etc/shadow are buggered). I haven't assessed the extent of the damage yet.

Still not sure whether it is related to the bug in question, of course.

Martin
