Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1CYVfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:35:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34934 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1CYVfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VssQxNbpDHcF5cY59Ldu82LX5D3IFcoB+PAoMxnKBUYvGK2Gv8OgxuE9OEzrYBj/vg
         MuKNM7Kgb0zEJYFL7L91J2XmZBLeyCRsdLxtOITB+U3+5ORnGa8c4Uv9FpHeB33VqqKj
         KzMZzZYBK85l8yCWVepZMAyxba+IfE/9jHA7w=
MIME-Version: 1.0
In-Reply-To: <20110325133203.039794496@linutronix.de>
References: <20110325133039.521553268@linutronix.de> <20110325133203.039794496@linutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:34:52 -0400
X-Google-Sender-Auth: OCsx4ka9KM3BAa4CgHR_k_PMcCo
Message-ID: <AANLkTinmwi8qa2_OFWz7o2sJoa04cK8Kod0QvpwvcBgm@mail.gmail.com>
Subject: Re: [patch 2/2] bfin: Convert irq namespace
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
> -       __set_irq_handler_unlocked(irq, handle);
> +       __irq_set_handler_locked(irq, handle);

looks like a typo in your patch ?  should still be unlocked right ?
-mike
