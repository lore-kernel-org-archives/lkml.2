Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab1JYQCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:02:42 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:49820 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1JYQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:02:41 -0400
Date: Tue, 25 Oct 2011 17:58:59 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging 2/6] et131x: uintxy_t removal.
Message-ID: <20111025155859.GA2019@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon> <20111023171119.GB28657@electric-eye.fr.zoreil.com> <20111024203338.GD3851@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024203338.GD3851@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Einon <mark.einon@gmail.com> :
[...]
> I don't believe this is strictly necessary, as uintxy_ts are allowed,
> but ok - at least it makes the file homogeneous.

It's exactly the point : avoid mixing both types.

-- 
Ueimor
