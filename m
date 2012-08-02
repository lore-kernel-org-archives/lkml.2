Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2HBNAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:00:36 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:39997 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab2HBNAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:00:34 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2012 09:00:33 EDT
Message-ID: <501A722D.1070900@c-s.fr>
Date: Thu, 02 Aug 2012 14:27:25 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Huge performance degradation for UDP between 2.4.17 and 2.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm having a big issue with UDP. Using a powerpc board (MPC860).

With our board running kernel 2.4.17, I'm able to send 160000 voice 
packets (UDP, 96 bytes per packet) in 11 seconds.
With the same board running either Kernel 2.6.35.14 or Kernel 3.4.7, I 
need 55 seconds to send the same amount of packets.


Is there anything to tune in order to get same output rate as with 
Kernel 2.4 ?

Regards
Christophe
