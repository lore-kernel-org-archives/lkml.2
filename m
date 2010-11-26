Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0KZQm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:42:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:35095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0KZQmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:42:25 -0500
Message-ID: <4CEFE370.9030505@suse.cz>
Date: Fri, 26 Nov 2010 17:42:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: Unused config options in drivers/mtd (Re: running my kernel scanning
 scripts on your favourite part of the tree)
References: <alpine.DEB.2.00.1011090711410.5783@localhost6.localdomain6> <4CEE8B70.4070500@suse.cz> <alpine.DEB.2.00.1011261122140.13435@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.00.1011261122140.13435@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.11.2010 17:29, Robert P. J. Day wrote:
>   and, BTW, there are still dead config variables in the code that go
> back *several* major versions, even though i've documented them just
> as many times here:
> 
>   http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

That might be the problem - that you are document the bugs in your wiki,
instead of sending reports to the maintainers directly :).

Michal
