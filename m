Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2CGOZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:25:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59118 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2CGOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:25:29 -0500
Message-ID: <4F576FD5.2050208@gmail.com>
Date: Wed, 07 Mar 2012 06:25:25 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linux-netdev <netdev@vger.kernel.org>,
        Linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
 DMADBG_7=0x00008040
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ath9k craps out from time to time(more annoying if anything)

[44309.840830] ath: Failed to stop TX DMA, queues=0x001!
[44309.858246] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
[44309.858255] ath: Could not stop RX, we could be confusing the DMA 
engine when we start RX up
[44309.932801] ath: Failed to stop TX DMA, queues=0x001!
[44309.950352] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
[44309.950361] ath: Could not stop RX, we could be confusing the DMA 
engine when we start RX up
[44310.024301] ath: Failed to stop TX DMA, queues=0x001!
[44310.041641] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
[44310.041646] ath: Could not stop RX, we could be confusing the DMA 
engine when we start RX up
[44310.116316] ath: Failed to stop TX DMA, queues=0x001!
[44310.133909] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
[44310.133918] ath: Could not stop RX, we could be confusing the DMA 
engine when we start RX up
[44310.208021] ath: Failed to stop TX DMA, queues=0x001!
[44310.225752] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
[44310.225761] ath: Could not stop RX, we could be confusing the DMA 
engine when we start RX up
[44310.299922] ath: Failed to stop TX DMA, queues=0x001!
[44310.317579] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x00006040
[44310.317587] ath: Could not stop RX, we could be confusing the DMA 
engine whe


part of dmesg here:
http://fpaste.org/xew6/
I can supply full log if needed..

Justin P. Mattock
