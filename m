Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1FOJ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:59:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36965 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1FOJ76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AbcAu8Cxdfs4nzHFNRTS813KSObjEEU7cNG5/TbpGJTqb5Om2mz4P9FCbrdZWV9/k4
         LM2jxztbIDW4ZF+5dDiH9ilE9BfgnX72I+hVwHI/qR5ieZtzS7Y8D2M6qKNUncLdhof0
         LsiBePaWXMoHlaMoyD9uF+Rz8wRHBhA6Z0KU0=
MIME-Version: 1.0
In-Reply-To: <20110615081317.GL8141@htj.dyndns.org>
References: <20110614070732.GA3355@maxin>
	<20110614071540.GE8141@htj.dyndns.org>
	<BANLkTimHjVX6ymALT-ZBeSs1S+PRDRwQaQ@mail.gmail.com>
	<20110615081317.GL8141@htj.dyndns.org>
Date: Wed, 15 Jun 2011 10:59:57 +0100
Message-ID: <BANLkTimvNoS2ht7vYJn2w6EC9q78TQkhVA@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
From: Maxin B John <maxin.john@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, segooon@gmail.com, jkosina@suse.cz,
        tglx@linutronix.de, eike-kernel@sf-tec.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Jun 15, 2011 at 9:13 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Yeap, sounds mostly okay but there's no 'possible use after free'.
> Maybe something like, "devres uses the pointer value as key after it's
> freed, which is safe but triggers spurious use-after-free warnings on
> some static analysis tools.  Rearrange code to avoid such warnings".
>
Thanks a lot for this suggestion. I think, this describes the patch in
a much better way.

Warm Regards,
Maxin
