Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab2DZWtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:49:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41842 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZWtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:49:09 -0400
Date: Thu, 26 Apr 2012 15:49:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4-rc4 oom killer out of control.
In-Reply-To: <20120426224419.GA13598@redhat.com>
Message-ID: <alpine.DEB.2.00.1204261547250.15785@chino.kir.corp.google.com>
References: <20120426193551.GA24968@redhat.com> <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com> <20120426215257.GA12908@redhat.com> <alpine.DEB.2.00.1204261517100.28376@chino.kir.corp.google.com> <20120426224419.GA13598@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, Dave Jones wrote:

> Disabling it stops it hogging the cpu obviously, but there's still 8G of RAM
> and 1G of used swap sitting around doing something.
> 

Right, I eluded to this in another email because the rss sizes from your 
oom log weren't necessarily impressive.  Could you post the output of 
/proc/meminfo?
