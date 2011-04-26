Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1DZO2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:28:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59187 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1DZO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:28:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Zach Pfeffer <zach.pfeffer@linaro.org>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Tue, 26 Apr 2011 16:28:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110421130930.4be9e9e1@jbarnes-desktop> <BANLkTim5umALqafjA2e88UCLzMp9LQu3_Q@mail.gmail.com>
In-Reply-To: <BANLkTim5umALqafjA2e88UCLzMp9LQu3_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261628.38734.arnd@arndb.de>
X-Provags-ID: V02:K0:QpoeHA+QU+dT6fOj+RsU3Lo6o+XbFJ9G0GKW2No9Ywc
 cQs+tXyFVuxT5UO2YrUL8t9exd+I3xXcLFcZJCYGzH3EfMun5g
 1NJdI8SH80IxHYYQHZTdHCXMsjxKdebKn/vFPfzAnJbAI3RoPs
 5m6u5xU/KxPHSNi8OScfhXJWEnccAE3k10VFO+tvXUg4O3Fud6
 U2WEM7AARN3EPj/KRQDlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011, Zach Pfeffer wrote:

> I agree with Jesse that the separation of mapping from allocation is
> central to the current usage models. I realize most people didn't like
> VCMM, but it provided an abstraction for this - if software can handle
> the multiple mapper approach in a rational way across ARM than we can
> solve a lot of problems with all the map and unmap current solutions
> and we don't have to hack in coherency.
 
Any solution we come up with needs to work on only across ARM, but
also across other architectures. Fortunately, most have less weird
constraints, for instance some architecture have no concept of uncached
mappings (and don't need them), or there might be DMA ordering settings
that we have not yet seen on ARM.

	Arnd
