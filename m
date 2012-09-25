Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab2IYRK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:10:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab2IYRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:10:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] ARM: ux500: Fix initialisation order for UIBs
Date: Tue, 25 Sep 2012 17:10:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
References: <1348585812-32073-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1348585812-32073-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251710.17014.arnd@arndb.de>
X-Provags-ID: V02:K0:55XppzXL/qGCNIygdWVY+Qa7ZDFDv83ecw3ObysZjcS
 CgPVy2HYSa0qVaM7+LsymDSbFHV0m6f9I8ElWP7S6hnhHDnWKy
 ydu6Has3mC7Y9Q1NgxFt2/WSHcQdYIMyjtcD8TDqi7023yQzF/
 NBxmbb2xqxe+YIe6wQkQmXSvj499TPFbprLBXzPzT8VQ5VqtKr
 xZvRii4D9Fh64V999D1dN6MeiFUKPrG/z0hOigBXJqOIxYtEYW
 NiiM0nzeGrDR7w453Tff78kVxIS4xPKxZVfiDLvuNdfXd1ox7c
 ug7RGzF7BR9XsMv19LcuYf6qBJSOB8fglrwpFdDcKB6T8D7dY1
 ifVVqkGk+AVgy16lmQZw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012, Lee Jones wrote:
> 
> An earlier change prevented User Interface Boards (UIBs) from being
> initialised on boards which did not support them. This change had
> the undesired effect of reordering the UIB initialisation calls with
> I2C registration. Here we ensure UIBs are only setup after all
> required infrastructure is already in place.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
