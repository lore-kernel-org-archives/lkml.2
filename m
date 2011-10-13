Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1JMI3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:29:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1JMI3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:29:02 -0400
Message-ID: <4E96A14C.5050408@suse.cz>
Date: Thu, 13 Oct 2011 10:29:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] parisc: Kconfig: cleanup Kernel page size default
References: <1318423872.2336.19.camel@x61.thuisdomein>
In-Reply-To: <1318423872.2336.19.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.10.2011 14:51, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> "Kernel page size" still defaults to "4KB", for both 32 and 64 bit
> processors, when tested with "make ARCH=parisc menuconfig", which is
> good.

I think this paragraph would be nice to have in the changelog.

Michal
