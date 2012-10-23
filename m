Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2JWG4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:56:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47597 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2JWG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:56:48 -0400
MIME-Version: 1.0
In-Reply-To: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
Date: Tue, 23 Oct 2012 16:56:47 +1000
Message-ID: <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
Subject: Re: drm i915 hangs on heavy io load
From: Dave Airlie <airlied@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> (please Cc)
>
> I am running 3.7-rc2 and got recently hit a few times (under rc1, too)
> by hanging drm i915 while doing large io operations.

Does booting with i915.i915_enable_rc6=0 help?

(Daniel, looks like an ironlake).

Dave.
