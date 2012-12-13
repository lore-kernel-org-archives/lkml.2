Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2LMEF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:05:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37307 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2LMEFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:05:25 -0500
Date: Wed, 12 Dec 2012 20:01:59 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] pstore/ram: Fix bounds checks for mem_size, record_size,
 console_size and ftrace_size
Message-ID: <20121213035648.GA15226@lizard.lan>
References: <1355276964-2929-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355276964-2929-1-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 05:49:24PM -0800, Arve Hjønnevåg wrote:
> The bounds check in ramoops_init_prz was incorrect and ramoops_init_przs
> had no check. Additionally, ramoops_init_przs allows record_size to be 0,
> but ramoops_pstore_write_buf would always crash in this case.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---

Applied, thanks a lot!
