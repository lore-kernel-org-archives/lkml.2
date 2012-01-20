Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2ATWmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:42:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44485 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2ATWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:42:24 -0500
Date: Fri, 20 Jan 2012 22:43:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kashyap Gada <gada.kashyap@gmail.com>
Cc: gregkh@suse.de, john.stultz@linaro.org, arve@android.com,
        ccross@android.com, bringert@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: android: Fix struct definition warning
 from static to const
Message-ID: <20120120224332.4671e94c@pyramind.ukuu.org.uk>
In-Reply-To: <1327095198-15970-1-git-send-email-gada.kashyap@gmail.com>
References: <1327095198-15970-1-git-send-email-gada.kashyap@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 21:33:17 +0000
Kashyap Gada <gada.kashyap@gmail.com> wrote:

> diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
> index b4bc03e..4a00174a5 100644
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -680,7 +680,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	return ret;
>  }
>  
> -static struct file_operations ashmem_fops = {
> +const struct file_operations ashmem_fops = {

You've lost the static ?
