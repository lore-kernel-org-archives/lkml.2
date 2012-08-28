Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2H1IzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 04:55:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2H1IzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 04:55:01 -0400
Message-ID: <503C8762.5070607@itechnical.de>
Date: Tue, 28 Aug 2012 10:54:58 +0200
From: Heiko Nardmann <heiko.nardmann@itechnical.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Q: dlm_recoverd takes 100%
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:I7Krn3QW/K+2608zSZjhvUMkNrPd7KgiKQe/IpN5SK7
 0M0F1ZjAMCYGdR+pt3+7sXzLFUZcGxPOczNxicmL63aPP9wkWc
 0ienBU6LNCuarOy/v+Xz0s/evAHMvO1Lo/JZefZtA1essh6fXq
 6p/4KavNoL/emfiqUB9Rghj63+rb6zjLSSi7F2LlLbx3ZodQ2D
 zzsVEEvIjUjX5Vlvnixyv92BiqiKjZOZlHU6xqaW+ZL5k9UMdf
 Xh1EEBbeA+ZqaSDcwctFZFco0YT3Rp5RDHSoIAvoW99eh5XzGX
 60mqe1Eikn5iFHrAvMhFwR3OEhY+ZauKFKwAn8tG1i5wf1acua
 L5XMmOqM4CJlLr7QaZXCfaumkYT1xx995xcu2FmUw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi together,

maybe someone can give me a hint which ML to contact (if I am wrong here)?

In a two-node cluster system I see 'dlm_recoverd' taking 100% time of 
one cpu for around 6 minutes. Here is small excerpt from a 'top' output 
during that period:

top - 10:51:01 up 3 days, 17:21,  5 users,  load average: 10.19, 5.39, 2.76
Tasks: 536 total,   3 running, 533 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.2%us,  6.6%sy,  0.0%ni, 92.1%id,  0.1%wa,  0.0%hi, 0.0%si,  
0.0%st
Mem:  12183344k total, 11827540k used,   355804k free,   160332k buffers
Swap: 14417912k total,        0k used, 14417912k free,  8299364k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+ COMMAND
  3121 root      20   0     0    0    0 R 100.0  0.0   3:36.15 dlm_recoverd

The cluster nodes use a shared SAN (GFS2). The second node has been 
rebooted while I experience this behaviour. The real problem is that my 
application is unable to open a file on the SAN for these 6 minutes. 
After the reboot of the second node all is fine again and the 
application succeeds in opening the file. So I am not sure what can 
cause those two symptoms.

Thanks in advance for any hint!


Kind regards,

     Heiko
