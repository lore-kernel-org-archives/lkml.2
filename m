Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1F3F2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:28:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58837 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750958Ab1F3F2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:28:21 -0400
Date: Wed, 29 Jun 2011 22:28:10 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
Message-ID: <20110630052808.GA796@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
 <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 10:31:47AM +0900, MyungJoo Ham wrote:
> IRQ definitions are needed to be accessed by board support package codes
> as well. Because they are not only used by MAX8997 MFD device drivers,
> this patch pulls such definitions out of private header, which is meant
> for MAX8997 MFD device drivers.

Why is this needed?
