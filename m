Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab0EZHE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:04:59 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:64732 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0EZHE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nKnMG+Wvm0KQBfFbZB4jYgtZV1avTZTRmSo3GbzozL1u1CPyAK4aCDZpUikvHJrcGz
         R9WI1iOFIsWcV7PyjFy0hU0xibmLY89+caKBdsOIh0zPTUt3fvSH/DoxGKFI0BCUraT+
         pz1isj/0o0CLcby3fsV2bZU5nwk8PQNPk/76g=
Message-ID: <4BFCC813.50806@gmail.com>
Date: Wed, 26 May 2010 00:04:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: ath9k-devel@venema.h4ckr.net
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ath: Failed to stop TX DMA in 100 msec after killing last frame
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is new:
[ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last 
frame
[ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!

I don't have hal installed!! should I be concerned?

Justin P. Mattock
