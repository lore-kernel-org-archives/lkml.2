Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab1CWUGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:06:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59249 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1CWUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=MRcBCvqkyjRorHS6N4aA7F+YeJrvcXmZLxAWJo5u9fNHQRyiJc13QBosnexrHkAKpc
         2DL8oqFfNhccV4Wr/z6mAGXpLl2QDuzeXDZvk1Teq0d8sKsJWkih7JfE/zKbDFdod18U
         ZsS6OnQ5mXZxo/zzwrImVgTyQjS/IoZkMJHOw=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Mar 2011 13:05:47 -0700
Message-ID: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
Subject: Update on Android PM enhancements - CONFIG_HAS_EARLYSUSPEND and friends
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        devel@linuxdriverproject.org, Naveen Singh <nsingh@atheros.com>,
        Kalle Valo <kvalo@adurom.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Vipin Mehta <vmehta@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve,

What ever happened with your series on the Android PM extensions you
had submitted in 2009 [1] ? I'm working on ath6kl right now and I'm
going to remove all that early suspend crap as its not upstream and I
want to get ath6kl into upstream proper. Do you have plans for a
replacement? Since the thread covers wake locks, have you ironed out
what you are going to do with that as well?

[1] https://lists.linux-foundation.org/pipermail/linux-pm/2009-February/019498.html

  Luis
