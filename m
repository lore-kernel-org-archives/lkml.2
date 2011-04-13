Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab1DMEcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 00:32:48 -0400
Received: from science.horizon.com ([71.41.210.146]:65041 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751071Ab1DMEcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 00:32:47 -0400
Date: 13 Apr 2011 00:32:46 -0400
Message-ID: <20110413043246.24974.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davej@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: Linux 2.6.39-rc3
Cc: joro@8bytes.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Gaah, yes. Apparently that placement is correct and documented, and
> has been since the beginning.
>
> However, reality always takes precedence, so I think that for now
> we'll just have to revert the commit that added the uid: tag, and we
> can re-visit this issue when hopefully the tools have been fixed.

Note that the discussion on the libmount mailing list revealed a possible
kernel workaround: escape the hyphens as \055.  Damn hard to read for
a human, but it does parse correctly, and the workaround can be fixed
once the library updates have propagated.

In case it's useful.
