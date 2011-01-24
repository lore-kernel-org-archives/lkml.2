Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1AXFXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 00:23:38 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43510 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1AXFXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 00:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZoWvR2qKkwdc+Mq8AGJdyLguvjvKcVmhhT90dEPrja5tpNkCeHmJtRL+DX1fz8Z9qS
         3HkyfuHWA+J+4uoLVGj2CnOizIPlDcTgRXiK7VsRYdTSo6B5jRVCPg2SOHeIV7WUanpE
         dGXM0h9E3SbbeQ+B480ugCNultNfJYKcfSekE=
Date: Mon, 24 Jan 2011 13:23:28 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kernel: gcov: Makefile: Use proper ccflag flag in
 Makefile
Message-ID: <20110124052328.GE6971@cr0.nay.redhat.com>
References: <20110123225339.GA1435@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123225339.GA1435@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 05:53:42PM -0500, Tracey Dent wrote:
>Use the ccflags-y flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
>deprecated and should now be switched.  According to
>(documentation/kbuild/makefiles.txt)
>
>Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
