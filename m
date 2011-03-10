Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1CJKvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:51:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1CJKvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ek+6lZJEVCMCvD4bcOJQNjSxXYKOkR6PMq0H3n2/WMEwHK03rp+9wn33qfgOFrTV2f
         TyVftuipLB1vdmiveNUkVa3rrn5cn/61jHLS9PjqUpcNsFQtn1dQIP17dcc1NKOYqDXS
         w58F7Ikk6o9ARDBbpjgKwU6kkUSvyi+yqtR+Q=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 00/21] staging: ft1000: Coding style and minor fixes.
Date: Thu, 10 Mar 2011 11:51:14 +0100
Message-Id: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend because not compilable after last post.

V2: - update 2 patches (11,14) according review
    - fix compilation problem

Marek Belisko (21):
  staging: ft1000: Replace camelcase CardSendCommand function name.
  staging: ft1000: Fix coding style in card_send_command function.
  staging: ft1000: Fix coding style in dsp_reload function.
  staging: ft1000: Fix coding style in ft1000_reset_asic function.
  staging: ft1000: Fix coding style in ft1000_reset_card function.
  staging: ft1000: Fix identation in ftnet_ops struct.
  staging: ft1000: Fix coding style in init_ft1000_netdev function.
  staging: ft1000: Change return value for init_ft1000_netdev function.
  staging: ft1000: Fix coding style in reg_ft1000_netdev function.
  staging: ft1000: Fix coding style in ft1000_reset function.
  staging: ft1000: Fix coding style in ft1000_usb_transmit_complete
    function.
  staging: ft1000: Fix coding style in ft1000_copy_down_pkt function.
  staging: ft1000: Fix coding style in ft1000_start_xmit function.
  staging: ft1000: Fix coding style in ft1000_submit_rx_urb function.
  staging: ft1000: Fix coding style in ft1000_copy_up_pkt function.
  staging: ft1000: Fix coding style in ft1000_open function.
  staging: ft1000: Fix coding style in ft1000_close function.
  staging: ft1000: Fix coding style in ft1000_chkcard function.
  staging: ft1000: Fix coding style in ft1000_receive_cmd function.
  staging: ft1000: Fix coding style in ft1000_dsp_prov function.
  staging: ft1000: Fix coding style in ft1000_proc_drvmsg function.

 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    | 1724 +++++++++++-----------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    4 +-
 3 files changed, 872 insertions(+), 862 deletions(-)

