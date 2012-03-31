Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2CaTi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:38:58 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:32891 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2CaTiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:38:50 -0400
Message-ID: <4F775F42.5020406@fnac.net>
Date: Sat, 31 Mar 2012 21:47:14 +0200
From: Paul Chavent <paul.chavent@fnac.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Packet mmap payload alignment.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm playing with the packet mmap interface. After having success with SOCK_DGRAM, i would like to try SOCK_RAW packet mmap.

I would like to align my payload on 16 bytes boundary. On rx side, it's automatic. But on tx side, it lacks the possibility to tell to the kernel where to begin to read the data.

Do i miss something ?

Do you think it could be possible to have a "reserve" like on the rx side ?


Regards.

Paul.


P.S. : can you cc me your reply please ?
