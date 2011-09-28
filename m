Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1I1NUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:20:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1I1NUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:20:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 04/24] add missing __iomem to generic iounmap declaration
Date: Wed, 28 Sep 2011 15:19:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-5-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-5-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281519.52466.arnd@arndb.de>
X-Provags-ID: V02:K0:2qQxDBeamJzzwyxHgPqwF5IzjykmJSTcCsBgdjh810g
 PiBjn7PlCzCZCPApV2y+gbDmuGRlcD8mNOlK92cd99hmnYSkbp
 sKmY1WdsvbISbLQMrR/iAyQiJd4xVshy1R96CKe0yYKkJ4xfmR
 S1VKrvpiwoyIXswOujE1J9uWm7NQq+LMbcWU49AuYkd3Hv9WDr
 jRbZo05wjIZliTDwNIy/5iU7auG0dk577+i8AI+S3cxBLspt4e
 ub5KfAarrmnHEWKi26gFxMvWuAfsvTRNQbZo72NCL/dsm56jij
 1xNTMmqyyEKgdkRHhdxit8WjI1KL9n6WoiJWOJKxX7vePsEjGS
 v1lTJ1hJPI6199WW8Gfw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  include/asm-generic/io.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>
