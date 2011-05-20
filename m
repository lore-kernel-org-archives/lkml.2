Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab1ETXRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:17:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59451 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1ETXQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=W2UE4vsC6gIXvVsfMP/e3M479MJUlTxuCXAlxtzNaQEnf2WWkAF3dj9WtZPMVP40Vd
         1c+njP/PfW4ZhgOCd49csibGut0L1vyw8g5inJm6sfBAACjXjqJ3/Lca9oyPYHriWqmx
         VonuLHnPyBSJfhHqBvjFzjnKQDG5scNTQ3S2s=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 20 May 2011 16:16:28 -0700
Message-ID: <BANLkTikTOQbyz-sTAS09Hh5Go++3qgOJDg@mail.gmail.com>
Subject: Linux wireless support education video on YouTube
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, David Quan <David.Quan@atheros.com>,
        Kathy Giori <Kathy.Giori@atheros.com>,
        Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you have engineers who need to support the 802.11 Linux subsystem
you at times see yourself needing to educate each group through some
sessions. In hopes of reusing educational sessions I've decided to
record my own series and post it on YouTube. I've broken down each
logical component of the series into as small atomic pieces so we can
add / remove / update the series into a new baked improved playlist.
If you wish to contribute to this please feel free to send me your own
videos so I can extend the series.

The hope is to education engineers as quickly as possible and then
refer them to our wireless.kernel.org wiki for more information. The
playlist of the 4 videos is available via:

http://bit.ly/kYdfpg

There will be Q&A Session on May 25, 2011 at 8am PST, you can poke us
with questions on IRC:

IRC server: irc.freenode.net
Channel: #linux-wireless

The breakdown of the series covers:

  * Review of the 802.11 subsystem
  * Development process review
  * Daily snapshots / stable release of compat-wireless
  * Debugging 802.11 drivers
  * 802.11s review

PS. Thanks to Javier for providing his own session on 802.11s support
on mac80211

  Luis
