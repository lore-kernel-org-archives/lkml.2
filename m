Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0DFTf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:35:59 -0400
Received: from web114310.mail.gq1.yahoo.com ([98.136.183.52]:47881 "HELO
	web114310.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756736Ab0DFTfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:35:52 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 15:35:52 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=ZL22m3/NySYFylj3GqugeB9iRoLJmw3jLngMaESRMXGoWtkVIaDZqBjqopnlsuLvlR7dB9VHLV/8J1uw0tU2lOxuSSRO8EAhkMkHhHMlt5pe6B23sNoQwy8hpbmj0x6M+A+7JeNoc7kseZ9cTYaHhQ403GThTN3P72Zo0NUPlaM=;
Message-ID: <132589.32312.qm@web114310.mail.gq1.yahoo.com>
X-YMail-OSG: Y4DwB7wVM1luNdn5XfgkYGQtfPpa.g6Irg8VMUSTcaKhSxm
 r7UqowMQ8IVQU74aNERcTRFErDj5MPes2HQa1nD3zrKGKoFw0.WrkeXePWnj
 oHeufdVU3UlCdPA9RXGJTvM5an4cN.JSHMgtXoEMupA2xvDFwwE79oWnOeGB
 Sie7VMzCkzNWm_JkqX5ZjxHml.o5OLeZw3lQJIkTkLQDj7rwnDFAUysv976u
 P49p2f4gvUf_pqExveDbujREmRamQGr5RF2dhMhb1AZkz107lsCS12gTuPt6
 TsSNOU1VChdjZ
X-Mailer: YahooMailRC/324.3 YahooMailWebService/0.8.100.260964
Date: Tue, 6 Apr 2010 12:29:12 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Memory policy question for NUMA arch....
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On a NUMA host, if a driver calls __get_free_pages() then it will eventually invoke ->alloc_pages_current(..). The comment above/within alloc_pages_current() says 'current->mempolicy' will be used.So what memory policy will kick-in if the driver is trying to allocate some memory blocks during driver load time(say from probe_one)? System-wide default policy,correct?

What if the driver wishes to i) stay confined to a 'cpulist' OR ii) use a different mem-policy? How do I achieve this?
I will choose the 'cpulist' after I am successfuly able to affinitize the MSI-X vectors.

regards
Rick


      
