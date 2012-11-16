Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab2KPIJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:09:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPIJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:09:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH 13/14] misc: tsl2550: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 08:09:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org> <1353048646-10935-14-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1353048646-10935-14-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211160809.11226.arnd@arndb.de>
X-Provags-ID: V02:K0:oPo5+Nm0nJu9sVtwVkXoRGLA8pDrMRbC70Jg9HD5ERp
 2xE21iws5+XeezrDZZWoHLKQKcGbWL2aIIQ8i3hDoRt6+O+8vf
 zvanC0DFN1jXUgiijP+Jr2uct4U9Of/FQul4jS9JYEBb4GjBZS
 ggFiEmyJhklvmFMokiLGc/TrNuhYLV+Sf48dY3NZWvLEY1u6lf
 zJnSr2X0szv1n7Aq1V+yN9aMJvF5SjU2s6uP7jx2KDpHe/11v6
 ra78np9Nk+lUCFnZYl3mBBU8/joN1Af4AVe9hQrjYHm2ZGFCIo
 3CRWxIvQam6fkMstVmeLoPuBY738C+PgMcPcfbtLVTbvBGWVBA
 gu7e5VqBQ42xZArkt0oM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012, Tushar Behera wrote:
> No need to check whether unsigned variable is less than 0.
> 
> CC: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
