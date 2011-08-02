Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1HBUiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:38:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52805 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab1HBUiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:38:07 -0400
Message-ID: <4E38601F.5090808@zytor.com>
Date: Tue, 02 Aug 2011 13:37:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Fix clashes with DRM updates
References: <20110726161536.4910.21396.stgit@localhost.localdomain>
In-Reply-To: <20110726161536.4910.21396.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 09:15 AM, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> The private object support has migrated from gma500 into the DRM core,
> remove our now clashing copy so -next can build.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

This patch is needed in Linus' tree, as it is currently causing a build
failure for either i386 or x86_64 allyesconfig.

	-hpa

