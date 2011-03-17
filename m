Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1CQHoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:44:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55891 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750898Ab1CQHn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:43:59 -0400
Content-Type: text/plain; charset="utf-8"
Date: Thu, 17 Mar 2011 08:43:56 +0100
From: sctp@muskelshirt.de
Message-ID: <20110317074356.231320@gmx.net>
MIME-Version: 1.0
Subject: sctp panic
To: linux-kernel@vger.kernel.org
X-Authenticated: #113584424
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19n5Idty/NnZL3EBVG8n3RR8aHTVptSyNcdTQCjkD
 f0wFdcCLyOXTchOUH12p7WdMxVG0IDiHV5OA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 3dfqJRUPTlI8VUBMsm5rColOU2poZRlN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

when doing the actions below I get a panic.

- echo 1 > /proc/sys/net/sctp/addip_enable 
- In a C-Programm  
    - socket(AF_INET,SOCK_STREAM,IPPROTO_SCTP);  
    - connect(....)     (with correct filled parameters)

Its no process (waiting in accept) neccessary

br
walter
-- 
GMX DSL Doppel-Flat ab 19,99 Euro/mtl.! Jetzt mit 
gratis Handy-Flat! http://portal.gmx.net/de/go/dsl
