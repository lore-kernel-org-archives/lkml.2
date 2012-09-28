Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2I1Aki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:40:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45440 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab2I1Ajh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:39:37 -0400
Date: Thu, 27 Sep 2012 17:36:55 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 00/57] power: Upgrade to ux500 battery management driver
Message-ID: <20120928003655.GA5765@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <20120927033806.GA22791@lizard>
 <5064CE6B.7020107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5064CE6B.7020107@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 04:08:43PM -0600, Mathieu Poirier wrote:
[...]
> I am half way through your comments - some I can handle myself, for
> others I needed to go back to the original author for clarification.
> Another set will follow shortly.

Yeah, I understand that it's mostly not your patches. All the patches
passed my 'sanity' tests, i.e. it was all checkpatch clean, warnings and
sparse clean, so I was quite relaxed about this series.

But taking a closer look, I see there are some serious issues. And of
course that the main problem with the patches is that patch descriptions
often insufficiently (if at all) decribe the reasoning behind the changes.

With time it will get even worse: nobody would be able to reach the
authors, or they will no longer remember the details.

So, I guess it's in everybody's interest to fix it.

Thanks,
Anton.
