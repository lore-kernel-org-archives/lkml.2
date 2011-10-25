Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1JYQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:02:56 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:49832 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1JYQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:02:54 -0400
Date: Tue, 25 Oct 2011 17:59:21 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging 6/6] et131x: uncloak PCIe capabilities.
Message-ID: <20111025155921.GC2019@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon> <20111023171214.GF28657@electric-eye.fr.zoreil.com> <20111024195602.GA3473@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024195602.GA3473@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Einon <mark.einon@gmail.com> :
[...]
> The PCIe changes are good, however I think using gotos here doesn't add
> anything as there's no difficult locking to navigate and makes the code
> harder to read.
> both out: and err_out: are used to return an error, and the backwards
> jumping goto makes me a bit uncomfortable. Could you respin with just the
> PCIe changes?

I confess I use a 55 lines vi split terminal when reviewing these blocks.

As there is no documentation to check the remaining PCIe candidate bits,
it's probably not worth it anyway.

-- 
Ueimor
