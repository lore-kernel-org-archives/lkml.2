Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KVScu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:32:50 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:49591 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KVScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:32:48 -0500
Message-ID: <1353607620.12263.2.camel@gitbox>
Subject: Re: [PATCH 0/4] video: vt8500: cleanup and use of devm_ apis
From: Tony Prisk <linux@prisktech.co.nz>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        FlorianSchandinat@gmx.de, patches@linaro.org
Date: Fri, 23 Nov 2012 07:07:00 +1300
In-Reply-To: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
References: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 12:12 +0530, Tushar Behera wrote:
> Patch 1 fixes a possible memory leak in the driver.
> Rest 3 patches add/update usage of devm_ apis.
> 
> These patches are only build-tested.
> 
> Tushar Behera (4):
>   video: vt8500: Fix memory leak in probe function
>   video: vt8500: Fix invalid free of devm_ allocated data
>   video: vt8500: Convert to use devm_request_mem_region()
>   video: vt8500: Convert to use devm_ioremap()
> 
>  drivers/video/vt8500lcdfb.c |   47 +++++++++++++++---------------------------
>  1 files changed, 17 insertions(+), 30 deletions(-)
> 

Thanks for the tidy up.
All patches Acked-by: Tony Prisk <linux@prisktech.co.nz>


