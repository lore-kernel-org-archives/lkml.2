Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2FMNTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:19:45 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:58515 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2FMNTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:19:43 -0400
Date: Wed, 13 Jun 2012 10:19:28 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Marcel Selhorst <tpmdd@selhorst.net>,
        Peter Huewe <peter.huewe@infineon.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Luigi Semenzato <semenzato@google.com>, andi.shyti@gmail.com,
        key@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] char/tpm: Add new driver for Infineon I2C TIS TPM
Message-ID: <20120613131927.GA8806@localhost.br.ibm.com>
References: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
 <20120613093744.Horde.0yc-Slm5A05P2ENIeQK2pwA@mail.selhorst.net>
 <CAOesGMh6wkHk6mwJ29RJ-wnc0uUd5SVMqgboG590CTrYzWfJ_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMh6wkHk6mwJ29RJ-wnc0uUd5SVMqgboG590CTrYzWfJ_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061313-9254-0000-0000-00000947A9E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Olof Johansson wrote:

> Marcel,
> 
> On Wed, Jun 13, 2012 at 12:37 AM, Marcel Selhorst <tpmdd@selhorst.net> wrote:
> >
> > Signed-off-by: Marcel Selhorst <tpmdd@selhorst.net>
> 
> Signed-off-by usually means "I touched this patch", as in applied it,
> or forwarded it (or modified and forwarded it). See
> Documentation/SubmittingPatches for full explanation. Do you mean
> Acked-by or Reviewed-by here instead?
> 
> Who picks up this patch and feeds it upstream for linux-next and 3.6? Rajiv?
>

Hi Olof,

It's currently me, and very soon will start being Kent Yoder
<key@linux.vnet.ibm.com> given this:

https://github.com/srajiv/tpm/commit/cbb2d5e459f4e10b3f1d11c23c31aa5d7c21e34c

I'll review it and have Kent taking a look as well.

Thanks,
Rajiv


