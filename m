Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2JPKyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:54:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58159 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2JPKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:54:21 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-01-507d3cd42e23
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'James Hogan'" <james.hogan@imgtec.com>, "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
Subject: RE: [PATCH] dw_mmc: fix multiple drv_data NULL dereferences
Date: Tue, 16 Oct 2012 19:54:12 +0900
Message-id: <001701cdab8c$93e1eac0$bba5c040$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rfJeFv+Up+NZOQYWdKkAhKIa+EQADeoAw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd2rNrUBBuvvsFhc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKWnXvKWvCQpWLNSdcGxh/MXYycHBICJhITehayQdhi
	EhfurQeyuTiEBBYxSrzvncoO4fxhlGjvmskIUsUmoCXx980bZpCEiMBiRon/C+aAJZgF0iU+
	/DzPDmILCbhJrDz0E2wsp4C7RNPOG0wgtrCAi8TfxVfA4iwCqhLvn7SDxXkFbCVuX7zKAmEL
	SvyYfI8FYqaBxPtZfawQtrzE5jVvgRZzAJ2qLvHory5IWETASOLmwm5miBIRiX0v3jFOYBSa
	hWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSH9TGoH48oGi0OM
	AhyMSjy8Gc41AUKsiWXFlbmHGCU4mJVEeJPNawOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7
	pAQICaQnlqRmp6YWpBbBZJk4OKUaGGUTObNDD55+fr/yBvfmyVUsefm/1fRuXdV3O915y3dn
	wYIt4QdFWVtuT92oV7Xc/4oJp7GTNW/ftr2vzasOfeRZ0e0vws8oYJl07dTcVxL9crr/uMTe
	z/7ucc5SkavH/KqJyPNXRW8XhX/XfK5gZeLGsTEzRbwu/EnhwvnvbThT7yuuYZNmUGIpzkg0
	1GIuKk4EAB/DYehlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 16, James Hogan <james.hogan@imgtec.com>
> Commit 800d78bfccb3d38116abfda2a5b9c8afdbd5ea21 ("mmc: dw_mmc: add
> support for implementation specific callbacks") merged in v3.7-rc1.
> 
> The above commit introduced multiple NULL pointer dereferences when
> the default dw_mci_pltfm_probe() is used, as it sets host->drv_data to
> NULL, and that's only checked against NULL in 1 out of the 7 cases where
> it is dereferenced.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Looks good to me.
Thanks.

Seungwon Jeon

