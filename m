Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab2BNNxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:53:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:36999 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616Ab2BNNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:53:41 -0500
Subject: Re: [PATCH 00/40] arch: set_current_blocked() and block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1329227102.2395.58.camel@deneb.redhat.com>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <1329227102.2395.58.camel@deneb.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 13:52:54 +0000
Message-ID: <1329227574.3675.65.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 08:45 -0500, Mark Salter wrote:
> The c6x patch seems to be missing from the series.

I don't think it is. It reached lkml.org OK,

	https://lkml.org/lkml/2012/2/14/123

The post to the linux-c6x-dev mailing list is awaiting moderator
approval but seeing as you were Cc'd on the patch I would have expected
it to reach your inbox with problems.

-- 
Matt Fleming, Intel Open Source Technology Center

