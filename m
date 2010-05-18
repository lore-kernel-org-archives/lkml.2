Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0ERIs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:48:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36477 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0ERIs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:48:26 -0400
Date: Tue, 18 May 2010 10:48:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH -v5 00/14] ACPI, APEI support
Message-ID: <20100518084824.GB22675@basil.fritz.box>
References: <1274164524-6092-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274164524-6092-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 02:35:10PM +0800, Huang Ying wrote:
> This patchset adds the APEI (ACPI Platform Error Interface) support to
> Linux kernel.
> 
> Changelog:
> 
> v5:
> 
> - Incorporate some fixes to previous version
> 
> - Add EINJ parameter support: 13, 14

Haven't reread everything, but the new parameter support looks good
to me.  Also the original patchkit -- which I read completely -- 
was looking good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
