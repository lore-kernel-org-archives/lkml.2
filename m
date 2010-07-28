Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0G1DL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:11:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40908 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0G1DLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FilWeJ8s1yRnDBAn4GZbaBB5Ib7Vdv+oc/NR3DXBMkfbmbk+SNbhjvX0uyTmt97VY7
         AMyR9EzipcYgZntrjm/h4hK8iIhwFNMSLH0CYqtFqPMXsgU2AHqDGW5KXNS0BoxIxEH8
         1tjCHslvDhM//f3pndTzfZJxZb3UHcU/ZCdr8=
Date: Wed, 28 Jul 2010 11:16:03 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Israel Schlesinger <israels@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, akpm@linux-foundation.org,
        joe@perches.com
Subject: Re: [PATCH v2] checkpatch: Add warnings for use of mdelay()
Message-ID: <20100728031603.GB5161@cr0.nay.redhat.com>
References: <4C4F16EE.9010008@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F16EE.9010008@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 10:27:10AM -0700, Israel Schlesinger wrote:
>mdelay is a busy-wait loop which is wasteful. If at all possible,
>callers should use msleep instead of mdelay.
>
>The only time mdelay is really appropriate is in atomic context,
>however, delays of 1ms+ in atomic context are rather expensive, so
>a warning for this case is probably appropriate as well to encourage
>people to move such expensive delays outside of atomic context
>

Then udelay() is also preferred...
