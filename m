Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0JPAUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:20:11 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:38273 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040Ab0JPAUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:20:10 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2010 20:20:10 EDT
From: "werner" <w.landgraf@ru.ru>
Subject: 2-6-36-rc2-git1 ploblem
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 15 Oct 2010 19:20:03 -0400
Message-ID: <web-387129527@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/das08_cs.c: In function 
'das08_pcmcia_config_loop':
drivers/staging/comedi/drivers/das08_cs.c:225: error: 
'struct pcmcia_device' has
no member named 'io'
make[4]: [drivers/staging/comedi/drivers/das08_cs.o] Error 
1 (ignored)
   CC [M]  drivers/staging/comedi/drivers/ni_daq_700.o
drivers/staging/comedi/drivers/ni_daq_700.c: In function 
'dio700_config':
drivers/staging/comedi/drivers/ni_daq_700.c:587: warning: 
unused variable 'req'
---
Professional hosting for everyone - http://www.host.ru
