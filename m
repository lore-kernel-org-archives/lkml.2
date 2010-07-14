Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0GNQ6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43521 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab0GNQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:58:46 -0400
Message-ID: <4C3DEC90.8060603@zytor.com>
Date: Wed, 14 Jul 2010 09:57:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Shishkin <virtuoso@slind.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        Sebastian Dalfu? <sd@sedf.de>, Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] implement size_append in perl
References: <1279116063-4499-1-git-send-email-virtuoso@slind.org> <20100714152337.GA13125@merkur.ravnborg.org> <20100714161704.GE23436@shisha.kicks-ass.net>
In-Reply-To: <20100714161704.GE23436@shisha.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 09:17 AM, Alexander Shishkin wrote:
> 
> Hm, maybe this mkpiggy can be made arch-independent and moved to scripts/
> as well?
> 

It depends on which architectures want this wrapping format.

	-hpa
