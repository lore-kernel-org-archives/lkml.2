Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0EBApx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 20:45:53 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:52161 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0EBApv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 20:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Pld7seP576HdFFajgUOyS8mXKrxqqrYV93HXAJNuRk8Yw41TJ2/NmtXVZ1fbRbL7bI
         jtedLToSftnWwlFOfp/b3JkZfucROWKm/K0RojGonvOzSblNycLZgn70zbQGCdiRbFgN
         pzPeCJtlHpQG6z892l071z5G2UtEVV9BCx8qk=
MIME-Version: 1.0
In-Reply-To: <1271481151-9589-1-git-send-email-linus.walleij@stericsson.com>
References: <1271481151-9589-1-git-send-email-linus.walleij@stericsson.com>
Date: Sat, 1 May 2010 17:45:50 -0700
X-Google-Sender-Auth: b1c33df759537bf0
Message-ID: <z2re9c3a7c21005011745te4a8de7fn16d26737c9fcd1af@mail.gmail.com>
Subject: Re: [PATCH 2/3] DMAENGINE: DMA40 logical channel fixes
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Jonas Aaberg <jonas.aberg@stericsson.com>,
       Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 10:12 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This fixes some small bugs relating to the handling of logical
> channels in the DMA40 driver:
>
> - Fix a bug when asking for paused status of a logical channel
>  would fail (bug found by Jonas Aaberg)
> - Handle DMA channel request for logical channel 0 (bug found by
>  Marcin Mielczarczyk)
>
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---

I appreciate the environmentally friendly aspect of combining two
fixes into one patch :-).  But if there are two fixes with two
changelogs can we have two patches?  Future developers looking to do
reverts and bisects will appreciate the upfront effort.

--
Dan
