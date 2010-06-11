Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab0FKSaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:30:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36732 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759922Ab0FKSaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=q6UkoNcYbqsXxpWXZm4w/yO1+JUbjtwxTY+qLf3MTgmiFr9a+n2tsnEEKWzCltUH7x
         YFwbXrV+taaqwtN7znJOB6Wtv+h69pdwXNvfKwUnS9J1peZ1MSdBvld74fyXcaNwCblW
         7LRWgkskl5I/QtubP+yCGdA8bRjEDGZv2RuAE=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 11 Jun 2010 11:29:53 -0700
Message-ID: <AANLkTikx7UuxgGRjo1TViZ2ZxU9DVmnErBoef13pKftd@mail.gmail.com>
Subject: compat-wireless based on 2.6.35-rc2 pushed out
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its on the stable page now:

http://wireless.kernel.org/en/users/Download/stable

tarball: http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.35/compat-wireless-2.6.35-rc2.tar.bz2
sha1sum: 6b2f040c965bffd4a659a7f4771832a9b7b568e5
ChangeLog: http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.35/ChangeLog-2.6.35-rc2-wireless

This actually has all the changes from Linus' tree as of today so it
actually has extra stuff on top of rc2, its more like an rc3. I
spotted these merged already:

$ git shortlog  v2.6.35-rc2.. net/mac80211/ net/wireless/ drivers/net/
drivers/bluetooth/

Abhijeet Kolekar (1):
      iwl3945: fix internal scan

Bob Copeland (1):
      ath5k: retain promiscuous setting

Bruno Randolf (1):
      ath5k: fix NULL pointer in antenna configuration

David S. Miller (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

Denis Kirjanov (1):
      8139too: fix buffer overrun in rtl8139_init_board

Emmanuel Grumbach (1):
      iwlwifi: move sysfs_create_group to post request firmware

Grazvydas Ignotas (1):
      wl1251: fix a memory leak in probe

Holger Schurig (1):
      mac80211: fix function pointer check

Jason Dravet (1):
      p54usb: Add device ID for Dell WLA3310 USB

Johannes Berg (3):
      mac80211: process station blockack action frames from work
      iwlwifi: add missing rcu_read_lock
      mac80211: fix deauth before assoc

John W. Linville (1):
      Revert "wireless: hostap, fix oops due to early probing interrupt"

Jussi Kivilinna (1):
      asix: check packet size against mtu+ETH_HLEN instead of ETH_FRAME_LEN

Linus Torvalds (1):
      Merge git://git.kernel.org/.../davem/net-2.6

Reinette Chatre (1):
      iwl3945: enable stuck queue detection on 3945

Timo Teräs (1):
      r8169: fix random mdio_write failures

Tobias Doerffel (1):
      ath5k: depend on CONFIG_PM_SLEEP for suspend/resume functions

  Luis
