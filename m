Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754Ab2DLBp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:45:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53507 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761736Ab2DLBp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <1334176305-6183-1-git-send-email-philippedeswert@gmail.com>
References: <1334176305-6183-1-git-send-email-philippedeswert@gmail.com>
Date: Thu, 12 Apr 2012 10:45:25 +0900
Message-ID: <CAKYAXd8Ofmg+kzUgr26CngaNgcw-MXJ91cS4R+BcMLY7yPxjNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: Avoid null pointer dereference
From: Namjae Jeon <linkinjeon@gmail.com>
To: Philippe De Swert <philippedeswert@gmail.com>, Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.calixto@modsystems.com, prakity@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/12 Philippe De Swert <philippedeswert@gmail.com>:
> After the null check on md the code jumped to cmd_done, which then
> will dereference md in mmc_blk_put. This patch avoids the possible
> null pointer dereference in that case.
>
> Signed-off-by: Philippe De Swert <philippedeswert@gmail.com>
This patch is good also.
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
