Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0ETM3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:29:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0ETM3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:29:23 -0400
Date: Thu, 20 May 2010 14:29:19 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>
Subject: Re: RFC: dirty_ratio back to 40%
Message-ID: <20100520122919.GA3420@fancy-poultry.org>
References: <4BF51B0A.1050901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF51B0A.1050901@redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100519 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1+SuIc99aNIBHeg4qdRFrIwCsP3xNBWYytuwDh
 a63Tx2mHMNAGA71tRvdZ5Ly4VKY3us7enB5GJC0Pyow9fDRQpY
 tL/q8lkd0CLt7DUd/lm9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.2010, Larry Woodman wrote: 

> Increasing the dirty_ratio to 40% will regain the performance loss seen
> in several benchmarks.  Whats everyone think about this???

These are tuneable via sysctl. What I have in my /etc/sysctl.conf is

 vm.dirty_ratio = 4
 vm.dirty_background_ratio = 2
 
This writes back the data more often and frequently, thus preventing the
system from long stalls. 

Works at least for me. AMD Quadcore, 8 GB RAM.

