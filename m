Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0IYCZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 22:25:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47094 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0IYCZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 22:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O4bkbHKPD8JNEZ/iGdlJnSFIO3/Ebc3CNaeiGqKOQgXBw0ZEAyenC3rOO50gnL1U26
         oUMTi0g27nbkmANlv7+6Vc9E5e2wT6iZ3EVMuYBIMuRWNjGfNeIx3Uj+/on/Q2ja9PmB
         y5MfgbTYZgeMvERBzHbf05rPMZJCF8KhWvYn0=
MIME-Version: 1.0
In-Reply-To: <1285224585-29457-1-git-send-email-mfm@muteddisk.com>
References: <1285224585-29457-1-git-send-email-mfm@muteddisk.com>
Date: Sat, 25 Sep 2010 10:25:43 +0800
Message-ID: <AANLkTimvJ_2ud1Lksv7J3WbdJQOMw+346v6YByk_pVok@mail.gmail.com>
Subject: Re: [PATCH 01/20] kernel: change to new flag variable
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: matt mooney <mfm@muteddisk.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 2:49 PM, matt mooney <mfm@muteddisk.com> wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
>
> Signed-off-by: matt mooney <mfm@muteddisk.com>

ACK to the whole patch set.

Please Cc linux-kbuild when you send patches for makefiles.

Thanks!
