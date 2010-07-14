Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab0GNO4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:56:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab0GNOz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:55:59 -0400
Message-ID: <4C3DCFB3.1090801@zytor.com>
Date: Wed, 14 Jul 2010 07:54:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Shishkin <virtuoso@slind.org>
CC: linux-kbuild@vger.kernel.org,
        =?UTF-8?B?U2ViYXN0aWFuIERhbGZ1w58=?= <sd@sedf.de>,
        Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] implement size_append in perl
References: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
In-Reply-To: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 07:01 AM, Alexander Shishkin wrote:
> +size_append = $(PERL) -e 'print pack("V", (stat "$(lastword $1)")[7])'

Why the "lastword"?

	-hpa
