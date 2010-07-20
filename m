Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0GTHVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:21:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48577 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0GTHVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:21:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Jul 2010 16:16:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com
Subject: Re: [PATCH 5/8] v3 Update the find_memory_block declaration
Message-Id: <20100720161629.1551837f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C451E60.8080702@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	<4C451E60.8080702@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 22:56:16 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the find_memory_block declaration to to take a struct mem_section *
> so that it matches the definition.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

