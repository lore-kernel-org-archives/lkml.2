Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1AMPgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:36:55 -0500
Received: from nm18-vm1.bullet.mail.ird.yahoo.com ([77.238.189.217]:35154 "HELO
	nm18-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756691Ab1AMPgy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:36:54 -0500
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 467059.77535.bm@omp1015.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=sHnytJy+lfhughzrileh/guDwz3zcrnnRb9VdSH3VER6KXu8OegQtF9rbtec7iTagXMME+8ggIzVNlsaZifHB3xuRbQ4w/M/dZZhWp2FkYLVKTxCbYchh9iJGcxYA4r7FK6iPo1wFcLXvThLN+AEGbLAJxDOkWAivP4k4n1pfac=;
Message-ID: <395199.61799.qm@web29510.mail.ird.yahoo.com>
X-YMail-OSG: g9Juk2AVM1m2lMgkxFhTDAljwuXVwbsbmlmmDJ71Pa0thLy
 A3vc63zTdf5YzKnp9U3MA4j_U0cFsM.SFuKGYFzojB3V2xCNzUq4IaP4vIIl
 MQ0DPbdmuBQJPetwdU9EVYHD9gW6XA3jqmpAIp9GGHSPxsebWkhdAILuEqgV
 K5tgzkHKfD7FHQv0H2U7RVXxc4sesBj8IqSTNs1z3AX1O7wud9dt8MVR_RUH
 TOWkvXtJXdvkg54R_IFJSea8swirnEIeqwyZV3TjqGNBnUiLxEa1C9_Fed7U
 aDU14uCuyNiJJz8GLUKc-
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
Date: Thu, 13 Jan 2011 15:36:52 +0000 (GMT)
From: Francesco Alfano <edacedpa@yahoo.it>
Subject: Lose shared network resource
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 
I have a problem with the (exported) sharing of network resources. 
Initially i've used a sever with RedHat 7.3 kernel 2.4 now i've  installed 
Scientific Linux 5.5 with kernel 2.6.18-194.32.1.el5PAE with  Samba version 
3.0.33-3.29.el5_5.1. 

The problem is that I lose the network connection periodically, about 10  
minutes! 


I initially thought the problem was caused by a misconfiguration of  samba 
version of sl, that I installed on a client machine with windows  2000 the 
"Microsoft Windows Services for Unix" in order to use nfs connection  exported 
from linux server, but the problema arise equally. 


It's a serious problem for me because the disconnection of a mapped  drive on 
w2k (connected via smb or nfs) is causing the crash of a basic  application that 
tries to detect the presence every second of a new file  in shared resource. 


This problem was not present with the older version of linux !!! 


Thanks in advance for your help. 

-- 
-- 
Best Regards 
Francesco Alfano


      
