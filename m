Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0KIUdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:33:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56298 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0KIUc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=w0UhvgrJZMl+Uv19YQsAzxJ416AstjTA4guo+j4E+xOCyGlf4TAmBeTGBqLdwke7y+
         Q5ZKxIUtohV12TJsxoG4XScUTKQtAq8VhCz4ePfTvZrpI4kGDlihFBYVpvfGsZccgxYj
         6g6qrJePC7Su4/Dfgw3j+dhE3yc8iY/LYYbhU=
Message-ID: <4CD9AFF4.5020809@gmail.com>
Date: Tue, 09 Nov 2010 21:32:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: mems applications <mems.applications@st.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, carmine.iascone@st.com,
        matteo.dameno@st.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver
References: <> <1289323527-5501-1-git-send-email-carmine.iascone@st.com>
In-Reply-To: <1289323527-5501-1-git-send-email-carmine.iascone@st.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 06:25 PM, mems applications wrote:
> Add STMicroelectronics LIS331DLH digital accelerometer device driver

I'm no IIC guy, but why this goes to staging?

> From: Carmine Iascone <carmine.iascone@st.com>
> ---
>  drivers/staging/Kconfig               |    2 +
>  drivers/staging/Makefile              |    1 +
>  drivers/staging/lis331dlh/Kconfig     |    7 +
>  drivers/staging/lis331dlh/Makefile    |    1 +
>  drivers/staging/lis331dlh/lis331dlh.c |  836 +++++++++++++++++++++++++++++++++
>  drivers/staging/lis331dlh/lis331dlh.h |   83 ++++
>  6 files changed, 930 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/lis331dlh/Kconfig
>  create mode 100644 drivers/staging/lis331dlh/Makefile
>  create mode 100644 drivers/staging/lis331dlh/lis331dlh.c
>  create mode 100644 drivers/staging/lis331dlh/lis331dlh.h


regards,
-- 
js
