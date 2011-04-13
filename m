Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1DMR4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:56:54 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:57180 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1DMR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:56:53 -0400
Date: Wed, 13 Apr 2011 19:48:52 +0200
From: =?utf-8?B?RnJhbsOnb2lz?= Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: bp@amd64.org, romieu@fr.zoreil.com, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Be verbose when unable to load fw patch
Message-ID: <20110413174852.GC17579@electric-eye.fr.zoreil.com>
References: <1302615172-1646-1-git-send-email-bp@amd64.org> <20110412.162036.241924043.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412.162036.241924043.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:20:36PM -0700, David Miller wrote:
[...]
> Seems reasonable, Francois?

Yes, it makes sense.

The patch goes way beyond 80 cols but I'll do a round of
cleanups later anyway.

-- 
Ueimor
