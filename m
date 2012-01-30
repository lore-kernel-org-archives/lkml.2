Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2A3H1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:27:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56343 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2A3H1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:27:11 -0500
Message-ID: <4F26468C.4000302@linaro.org>
Date: Mon, 30 Jan 2012 11:28:12 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH] module: avoid call vmalloc if init size is zero
References: <1327648756-22255-1-git-send-email-dmitry.antipov@linaro.org> <8762fxcrvx.fsf@rustcorp.com.au>
In-Reply-To: <8762fxcrvx.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 03:21 PM, Rusty Russell wrote:

> Please fix __vmalloc_node_range() instead to return ZERO_SIZE_PTR.
> And of course, vfree() to use ZERO_OR_NULL_PTR().

For the convenience and uniformity, should {alloc,free}_percpu() be
also modified in that way?

Dmitry
