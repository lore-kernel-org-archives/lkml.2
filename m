Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1AYFja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:39:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48473 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1AYFj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:39:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kNPuM7eSz8g7OhOxUsn/iTYFYGpC0sjYbuaCzSWMAVpx8Gt1PbXn//vHIbg1dPK/KU
         76Qhwfjl+UM3I9SZq2ino8A1pNBRDivS1A+5q253BX7hIHvyOhXVLGZJoWBNhq52qGL0
         YB8/VdwfG7IcE8zGsZljncAxvKRLuAV5/GCgA=
Date: Tue, 25 Jan 2011 13:39:17 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Shane Wang <shane.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        jonmccune@cmu.edu, joseph.cihula@intel.com
Subject: Re: [PATCH] intel_txt: Add more explicit dependencies for
 CONFIG_INTEL_TXT
Message-ID: <20110125053917.GB13618@cr0.nay.redhat.com>
References: <1296067042-13485-1-git-send-email-shane.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296067042-13485-1-git-send-email-shane.wang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 02:37:22AM +0800, Shane Wang wrote:
>This patch is to follow the recommended way in kconfig-language.txt to use HAVE_INTEL_TXT, so to add more explicit dependencies for CONFIG_INTEL_TXT.
>
>Signed-off-by: Jonathan McCune <jonmccune@cmu.edu>
>Signed-off-by: Shane Wang <shane.wang@intel.com>
>

Yes, this looks better.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
