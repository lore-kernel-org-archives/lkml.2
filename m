Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2JNRLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 13:11:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21561 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2JNRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 13:11:47 -0400
Message-ID: <507AF253.1030108@tilera.com>
Date: Sun, 14 Oct 2012 13:11:47 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/25] tile: Use Kbuild infrastructure for kvm_para.h
References: <20121013022632.024527228@goodmis.org> <20121013022955.456205573@goodmis.org>
In-Reply-To: <20121013022955.456205573@goodmis.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/12/2012 10:26 PM, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> All the headers but kvm_para.h use the Kbuild infrastructure to
> get to the asm-generic headers.
>
> Cc: linux-kbuild@vger.kernel.org
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/tile/include/asm/Kbuild     |    1 +
>  arch/tile/include/asm/kvm_para.h |    1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  delete mode 100644 arch/tile/include/asm/kvm_para.h

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

