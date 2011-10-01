Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1JALgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 07:36:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1JALgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 07:36:47 -0400
Subject: Re: [PATCH] jffs2/security.c: local functions should be static
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Sat, 01 Oct 2011 14:39:47 +0300
In-Reply-To: <201109231556.15973.hartleys@visionengravers.com>
References: <201109231556.15973.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317469194.19426.86.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 15:56 -0700, H Hartley Sweeten wrote:
> Quiets the sparse noise:
> 
> warning: symbol 'jffs2_initxattrs' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>

Against which tree is this patch? My l2-mtd-2.6 tree does not have this
function, and it is based on Linux 3.1-rc2.

-- 
Best Regards,
Artem Bityutskiy

