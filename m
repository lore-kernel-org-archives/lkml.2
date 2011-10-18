Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1JRJAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:00:08 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:33756 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1JRJAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:00:06 -0400
Date: Tue, 18 Oct 2011 04:59:58 -0400 (EDT)
From: David Airlie <airlied@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] RADEON: Drop inlines from evergreen_cs.c / r600_cs.c
Message-ID: <b5ab3dc3-19a7-47b4-8c4d-8e606eb7f729@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.5.166]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> From: Andi Kleen <ak@linux.intel.com>

Hi Andi,

I've merged all the RADEON: patches to drm-next locally, with one minor change (moving some of the out-of-lines to a more appropriate place).

Thanks,
Dave.
