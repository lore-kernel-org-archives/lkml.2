Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2HBKRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:17:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34858 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab2HBKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:17:20 -0400
Date: Thu, 2 Aug 2012 11:17:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V1 0/7] please comment on this new PMIC driver
Message-ID: <20120802101718.GF29157@opensource.wolfsonmicro.com>
References: <201208020849.q728ng3f007799@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208020849.q728ng3f007799@latitude.olech.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:48:58AM +0100, Anthony Olech wrote:
> This is submission attempt number 1 to have this driver included in
> the linux kernel source tree. This is the driver for the Dialog DA9058.

I just noticed that you haven't CCed the maintainers for most of this
stuff on your patches...  you should always do this if you want review.
