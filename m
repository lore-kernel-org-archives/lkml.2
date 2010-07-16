Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936071Ab0GPJAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:00:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49029 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936061Ab0GPJAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:00:18 -0400
Message-ID: <4C401F98.5080408@cs.helsinki.fi>
Date: Fri, 16 Jul 2010 12:00:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kmemleak: Show more information for objects found
 by alias
References: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com> <20100715150901.21793.2120.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715150901.21793.2120.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> There may be situations when an object is freed using a pointer inside
> the memory block. Kmemleak should show more information to help with
> debugging.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
