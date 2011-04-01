Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab1DAPy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:54:57 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:50598 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1DAPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:54:56 -0400
Message-ID: <4D95F54D.8020802@grupopie.com>
Date: Fri, 01 Apr 2011 16:54:53 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>	 <4D948D52.4040708@grupopie.com>  <1301669776.2789.92.camel@localhost>	 <1301670104.2789.94.camel@localhost>  <4D95F092.4080604@grupopie.com> <1301672549.2789.107.camel@localhost>
In-Reply-To: <1301672549.2789.107.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Fri, 2011-04-01 at 16:34 +0100, Paulo Marques wrote:
>>[...]
>> With an automatic makefile mechanism, the problem would go unnoticed and
>> it just wouldn't be fixed, increasing the kernel compile time for
>> everyone who hits the same troublesome configuration.
> 
> Yes, the build system may print a message:
> 
> Your symbols table is screwed, this is a bug, report about it. As a
> temporary workaround use "make KALLSYMS_EXTRA_PASS=1"
> 
> Or something like that.

Yes, I think that would work too, and it would even prevent the option
from being on for no good reason.

-- 
Paulo Marques - www.grupopie.com

"Nostalgia isn't what it used to be."
