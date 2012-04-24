Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2DXW4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:56:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59804 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab2DXW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:56:08 -0400
Date: Tue, 24 Apr 2012 15:56:14 -0700
From: Olof Johansson <olof@lixom.net>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Subject: Re: [PATCH 01/13] regulator: Fix DT node name checking in
 max8997-pmic
Message-ID: <20120424225614.GA14008@quad.lixom.net>
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
 <1334256332-29867-2-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334256332-29867-2-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Apr 12, 2012 at 08:45:20PM +0200, Karol Lewandowski wrote:
> Avoid hard lockup when someone provides non-supported regulator
> name.
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>

What is this supposed to apply against? It doesn't match any contents in
linux-next. Also, fixes like these should just go straight to Mark Brown (and
cc LAKML and others).


-Olof
