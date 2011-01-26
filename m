Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1AZSoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:44:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50303 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:44:04 -0500
Message-ID: <4D406B8A.1020107@vflare.org>
Date: Wed, 26 Jan 2011 13:44:26 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] zram/xvmalloc: free bit block insertion optimization
References: <20110126172148.GB8446@linux.vnet.ibm.com> <20110126172508.GF8446@linux.vnet.ibm.com>
In-Reply-To: <20110126172508.GF8446@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 12:25 PM, Robert Jennings wrote:
> There is no need to set the bits in the first- and second-level indices
> to indicate a free page when we know that a free page existed at this
> level.
>
> Signed-off-by: Robert Jennings<rcj@linux.vnet.ibm.com>
>

Reviewed-by: Nitin Gupta <ngupta@vflare.org>


Thanks for all the fixes and cleanups.
Nitin

