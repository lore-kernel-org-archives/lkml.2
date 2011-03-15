Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab1CONzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:55:39 -0400
Received: from lo.gmane.org ([80.91.229.12]:36441 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384Ab1CONzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:55:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
Date: Tue, 15 Mar 2011 13:55:26 +0000 (UTC)
Message-ID: <ilnr4d$rjj$3@dough.gmane.org>
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 122.232.152.135
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011 23:00:09 +0100, Jesper Juhl wrote:

> I believe the return type of main should always be 'int'.
> 

In user-space, yes, but this is not true in kernel space especially here.

