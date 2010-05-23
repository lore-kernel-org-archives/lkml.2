Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0EWGZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 02:25:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54174 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0EWGZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 02:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E9BRcaCPRFpSSewFWmm9n4DLMpPivvt/ed7ft0TUEJmcWTPOYl7I9ZboZL3YkRYt3I
         QbolpvrM5B18d6lzBAeE6O3pxcgKgp1JMrKiHoKnQLFqZLoqrQAkBDXwC/nPp+yr2+ko
         6dY/5nVzkIPf2hkw/+anEp6dra6kxegxH5l8k=
MIME-Version: 1.0
Date: Sun, 23 May 2010 11:55:43 +0530
Message-ID: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
Subject: iwl3945 bug in 2.6.34
From: Satish Eerpini <eerpini@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

I am running a custom compiled 2.6.34 (fedora 12) on a hp nx7400 with
a Intel Pro Wireless 3945 card, the card works fine and connects to a
WEP secure wireless connection on my router. But after some time
network manager starts reporting that the wireless access point is not
available anymore and tries to reconnect to the network, though the
network is still available, it fails to detect the network , I have
not been able to reproduce the situation conclusively, seems to be
happening randomly ... here is the tail from "dmesg" which looked
suspicious :
(btw, I also faced the same problem earlier when I was running RHEL
beta 6.0 on the same machine)

No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: IN
cfg80211: Regulatory domain changed to country: IN
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5250000 KHz - 5330000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 20000 KHz), (N/A, 2000 mBm)
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:10:00.0: Error setting new configuration (-110).
iwl3945 0000:10:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:10:00.0: No space in command queue
iwl3945 0000:10:00.0: Restarting adapter due to queue full
iwl3945 0000:10:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -28
iwl3945 0000:10:00.0: Error setting new configuration (-28).
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: BSM uCode verification failed at addr
0x00003800+0 (of 900), is 0xffffffff, s/b 0xf802020
iwl3945 0000:10:00.0: request scan called when driver not ready.
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
usb 2-1: USB disconnect, address 2
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:10:00.0: BSM uCode verification failed at addr
0x00003800+0 (of 900), is 0xffffffff, s/b 0xf802020

how can this be fixed ? I need to reboot the machine every time this happens,
please let me know if any other information is needed .

Cheers
Satish

--
http://tuxitter.blogspot.com
