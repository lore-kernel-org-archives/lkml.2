Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2BWUfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:35:43 -0500
Received: from zougloub.eu ([188.165.233.99]:58967 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab2BWUfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:35:42 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 15:35:41 EST
Date: Thu, 23 Feb 2012 15:26:04 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Sorin Dumitru <dumitru.sorin87@gmail.com>
Cc: Dan McGee <dpmcgee@gmail.com>, David Daney <david.daney@cavium.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [perf] perf top segfaulting
Message-ID: <20120223152604.3f224508@Malcolm>
In-Reply-To: <CAB6DaTO3nVHG7mhxKZDXEaTbV10UQ62qVBgTJDCQuY_ERREggA@mail.gmail.com>
References: <CAEik5nNsct2CL0Pfu8XaBGpZ4UOc-6EWtbk_LO5AxGzK9Vajjg@mail.gmail.com>
	<4F2C96F7.9070307@cavium.com>
	<CAEik5nOEBgtEf766CxcRPTXb5CnTdwn1JYm+yaaqV1aOTjpJ0g@mail.gmail.com>
	<CAB6DaTO3nVHG7mhxKZDXEaTbV10UQ62qVBgTJDCQuY_ERREggA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Feb 2012 10:59:28 +0200
Sorin Dumitru <dumitru.sorin87@gmail.com> wrote:

> I've sent a patch that works for me, but i don't know if it's the
> right solution at [1].
> 
> [1] https://lkml.org/lkml/2012/1/29/59

Hi,

Just to say that I had the issue on ARM and this patch works for me.

Regards,

-- 
cJ
