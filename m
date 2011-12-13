Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1LMQDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:03:54 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:35451 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1LMQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:03:51 -0500
Date: Tue, 13 Dec 2011 11:07:53 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, thellstrom@vmware.com
Subject: Re: [PATCH] fixes to drm-next - TTM DMA code (v1)
Message-ID: <20111213160753.GC2339@homer.localdomain>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 03:09:26PM -0500, Konrad Rzeszutek Wilk wrote:
> Jerome pointed me to some accounting error in the DMA API debugging code and
> while I can't figure it out yet, I did notice some extreme slowness - which
> is due to the nouveau driver calling the unpopulate (now that unbind +
> unpopulate are squashed) quite a lot (this is using Gnome Shell - I think GNOME2
> did not have those issues but I can't recall).
> 
> Anyhow these patches fix the 50% perf regression I saw and also some minor bugs
> that I noticed.
> 

Gonna review those today and test them.

Cheers,
Jerome
