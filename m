Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1CPNZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:25:18 -0400
Received: from r-mail1.rd.francetelecom.com ([217.108.152.41]:45322 "EHLO
	r-mail1.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab1CPNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:25:09 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 09:25:09 EDT
Message-ID: <4D80B7EE.40706@Free.fr>
Date: Wed, 16 Mar 2011 14:15:26 +0100
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110309 Lightning/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2011 13:15:27.0456 (UTC) FILETIME=[378E1600:01CBE3DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Trying to compile 2.6.38, I found the follwoing bug. Compiler barks...

diff linux-2.6.38/arch/x86/kernel/entry_32.S 
linux-2.6.38/arch/x86/kernel/entry_32.S~
1416c1416
< END(async_page_fault)
---
 > END(apf_page_fault)

--eric

