Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2DTLTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:19:40 -0400
Received: from smtp-out-025.synserver.de ([212.40.185.25]:1038 "EHLO
	smtp-out-012.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754485Ab2DTLTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:19:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25395
Message-ID: <4F9146D8.4060608@metafoo.de>
Date: Fri, 20 Apr 2012 13:22:00 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, grundler@chromium.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/2] staging: iio: light: convert multiple spaces to
 tab
References: <1334906858-25578-1-git-send-email-ldewangan@nvidia.com> <1334906858-25578-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334906858-25578-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 09:27 AM, Laxman Dewangan wrote:
> Using tab inplace of multiple spaces for indenting.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> As per Jonathan's feedback, creating this patch for only
> indenting cleanups.
> No change from V2
> No Change from V3
> 
> This is already acked by Jonathan.

When resending a patch that has already been acked or reviewed, include the
Acked-by or Reviewed-by line in the patch under your Signed-off-by.
