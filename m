Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab2AZJhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:37:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2AZJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:37:45 -0500
MIME-Version: 1.0
In-Reply-To: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
Date: Thu, 26 Jan 2012 18:37:44 +0900
Message-ID: <CAKYAXd9pXfL1S_KSLoF48AKNtxj9-svdDdXp=_DYZAmBvFFddg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
From: Namjae Jeon <linkinjeon@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/26 Seungwon Jeon <tgih.jun@samsung.com>:
> This patch supports packed command of eMMC4.5 device.
> Several reads(or writes) can be grouped in packed command
> and all data of the individual commands can be sent in a
> single transfer on the bus.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

Looks good to me also.
Thanks.
> ---
