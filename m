Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0IDGvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:51:36 -0400
Received: from freeflow.nu ([178.79.134.28]:56596 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0IDGvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:51:35 -0400
Message-ID: <4C81EC67.9070308@kernel.org>
Date: Sat, 04 Sep 2010 09:51:19 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] x86-32: Rewrite fpu_save_init()
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com> <1283563039-3466-12-git-send-email-brgerst@gmail.com>
In-Reply-To: <1283563039-3466-12-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 4.9.2010 4.17, Brian Gerst wrote:
> Rewrite fpu_save_init() to prepare for merging with 64-bit.
>
> Signed-off-by: Brian Gerst<brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>

