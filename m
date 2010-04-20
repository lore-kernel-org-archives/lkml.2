Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0DTNUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:20:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:47425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab0DTNUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:20:07 -0400
Message-ID: <4BCDAA05.50506@suse.cz>
Date: Tue, 20 Apr 2010 15:20:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.8 Thunderbird/3.0.4
MIME-Version: 1.0
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] globally ignore Module.symvers
References: <201004191642.52517.ffainelli@freebox.fr>
In-Reply-To: <201004191642.52517.ffainelli@freebox.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.4.2010 16:42, Florian Fainelli wrote:
> If we build using make SUBDIRS=foo/ Kbuild will output per-directory
> Module.symvers files that we do not want to keep track of. Ignore these files
> globally.

SUBDIRS= or M= is meant for external modules, which generate their own
Module.symvers. If you only need to build a part of the kernel sources,
use 'make dir/'.

Michal
