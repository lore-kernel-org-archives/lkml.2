Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0HEEvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:51:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60337 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0HEEvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:51:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 13:45:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/9] v4  Move the find_memory_block() routine up
Message-Id: <20100805134546.fa8f2f96.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C581B67.1010202@austin.ibm.com>
References: <4C581A6D.9030908@austin.ibm.com>
	<4C581B67.1010202@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:36:39 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Move the find_memory_block() routine up to avoid needing a forward
> declaration in subsequent patches.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

