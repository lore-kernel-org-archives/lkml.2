Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab1DNPQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:16:05 -0400
Received: from science.horizon.com ([71.41.210.146]:13978 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752802Ab1DNPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:16:04 -0400
Date: 14 Apr 2011 11:16:01 -0400
Message-ID: <20110414151601.675.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gorcunov@gmail.com
Subject: Re: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Cc: a.p.zijlstra@chello.nl, airlied@gmail.com, dzickus@redhat.com,
        eranian@google.com, linux@horizon.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com, sruffell@digium.com
In-Reply-To: <BANLkTi=k0GMrWV5covpnGBfB30UO14z-HA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> George, mind to give these patches a shot please? (Sorry for sending
> it as attachment).

It ran overnight with no problems.  (Well, I'm having a problem with udev
using 100% of CPU, but that appears to be unrelated.)

Thank you very much!

Acked-By: George Spelvin <linux@horizon.com>
