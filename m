Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2KZSDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:03:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:53451 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab2KZSCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:02:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,321,1352102400"; 
   d="scan'208";a="222508012"
Message-ID: <50B3AEA1.9010802@linux.intel.com>
Date: Mon, 26 Nov 2012 10:02:09 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jacob Shin <jacob.shin@amd.com>
Subject: Re: [PATCH 168/270] x86: Exclude E820_RESERVED regions and memory
 holes above 4 GB from direct mapping.
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com> <1353949160-26803-169-git-send-email-herton.krzesinski@canonical.com>
In-Reply-To: <1353949160-26803-169-git-send-email-herton.krzesinski@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 08:57 AM, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

What kind of version number is that?

	-hpa


