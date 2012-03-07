Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2CGECB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:02:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44335 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062Ab2CGEB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
References: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com>
	<1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
Date: Tue, 6 Mar 2012 20:01:58 -0800
Message-ID: <CAMP5XgfWBj_V+21avHyEbViYK1N0fHBmyj6CcYry0Fd4QttgqQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and buffer_size
 before used
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Zhengwang Ruan <ruan.zhengwang@gmail.com>
Cc: gregkh@linuxfoundation.org, chris+android@zenthought.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 6:36 PM, Zhengwang Ruan <ruan.zhengwang@gmail.com> wrote:
> GCC warns 'buffer' and 'buffer_size' are used with being uninitialized, and
> 'buffer' is used as returned value, and 'buffer_size' is initialized using
> uninitialized_var to clear warning.

Why do you clear the warning on buffer_size with uninitialized_var()
but not on buffer? Neither variable is used before being initialized.

-- 
Arve Hjønnevåg
