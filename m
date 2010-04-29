Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab0D3Rxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:53:31 -0400
Received: from mail.tpi.com ([70.99.223.143]:3910 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab0D3RxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:53:17 -0400
Message-ID: <4BD98002.6030308@canonical.com>
Date: Thu, 29 Apr 2010 13:48:02 +0100
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: romieu@fr.zoreil.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: r8169 stable updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois,

If not already proposed, I think these commits are appropriate for 
stable updates. Do you agree? They apply cleanly to 2.6.32 and will 
likely fix the symptoms of this bug: 
http://bugs.launchpad.net/bugs/562742 (still in test).

4c020a961a812ffae9846b917304cea504c3a733 r8169: use correct barrier 
between cacheable and non-cacheable memory

78f1cd02457252e1ffbc6caa44a17424a45286b8 r8169: fix broken register writes

908ba2bfd22253f26fa910cd855e4ccffb1467d0 r8169: more broken register 
writes workaround

rtg
-- 
Tim Gardner tim.gardner@canonical.com
