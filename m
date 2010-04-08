Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab0DHPhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:37:48 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:43365 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab0DHPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b5PpH9lB6d7doT6+URSBo/Lk3d7MFtbSU/+aEPDu1RO0LGYgcnttm4Z0eWKu2w/fPg
         OL7kLdABOvfZpHSfCFTSmdjRTkPszBGWcckKbtE3B/0O0JUJcemWXueTNsWZRxZuJlbp
         kHEwbtU+GKr7wkrnV7kxj1R2ZJYhzY2gFZolg=
Date: Thu, 8 Apr 2010 23:41:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       stable@kernel.org
Subject: Re: [PATCH] Revert "memory-hotplug: add 0x prefix to HEX
	block_size_bytes"
Message-ID: <20100408153745.GA4213@hack>
References: <20100408151006.GB2446@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408151006.GB2446@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 05:10:06PM +0200, Heiko Carstens wrote:
>From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
>Revert ba168fc37dea145deeb8fa9e7e71c748d2e00d74 "memory-hotplug: add 0x prefix
>to HEX block_size_bytes" since it changes the user space visible sysfs interface
>/sys/devices/system/memory/block_size_bytes.
>The change breaks existing user space applications which rely on the fact that
>the output does not contain the "0x" prefix.
>

Odd.

Which application relies on this? Isn't the application which should
be fixed?? It should use something like strtoul() which doesn't
rely on '0x' prefix.

Thanks.
