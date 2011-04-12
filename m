Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1DLNou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:44:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59162 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab1DLNot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:44:49 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.163.109]
In-Reply-To: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org>
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 12 Apr 2011 16:44:29 +0300
Message-ID: <BANLkTin7DEWJt4PrBp85disqXd9ZBG3Z_g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality V2
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lee.jones@linaro.org, patches@linaro.org, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 6:24 PM, <mathieu.poirier@linaro.org> wrote:
>
> From: Mathieu J. Poirier <mathieu.poirier@linaro.org>
>
> This is the second spin on STE's Hsem driver that is implemented
> through the hwspinlock scheme.  More specifically:
>
>  More comments have been added in the code.
>  Cleanup of included header files.
>  One of the original contributor's name corrected.
>  Calls to 'pm_runtime_disable'restored.
>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---

Looks good, but please revise the commit log (think of a random reader
who tries to understand what does this patch do, and is less
interested to hear about its revisions' history).

Otherwise,

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

(btw I assume the "PATCH 1/2" in the subject is just a typo, and
there's no missing "PATCH 2/2")
