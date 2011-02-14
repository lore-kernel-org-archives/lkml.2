Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1BNRzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:55:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33349 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1BNRzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EZ9d+TNN1uXeVo6SlmtQg0McZ6Cyb0Mf4MMpt1/BgsxvylOm4ho3FykrMtBSEVySHy
         /HsSdHbVqhKhaRZFOAJjn8q7nB0V4P2+0TNgYxxkuKYEafI8o6bgyWGfyGO0D5lOmi7b
         ysIyjulGR9EdKUE4MEFELcEWQfVs+K2D0lWrU=
MIME-Version: 1.0
In-Reply-To: <20110214162602.GB11290@dumpdata.com>
References: <4D50343E.1020906@kernel.org>
	<alpine.DEB.2.00.1102071839060.7277@kaball-desktop>
	<4D504161.2060900@kernel.org>
	<4D506A85.9030802@goop.org>
	<4D50B4B5.4050505@kernel.org>
	<4D519AAA.8070309@zytor.com>
	<4D547962.8040403@goop.org>
	<4D547B74.1030302@kernel.org>
	<4D54844B.4010007@zytor.com>
	<4D5488D5.2020607@kernel.org>
	<20110214162602.GB11290@dumpdata.com>
Date: Mon, 14 Feb 2011 09:55:49 -0800
X-Google-Sender-Auth: zTlxinaV1Qx1gjmv1NxJr4X_WV8
Message-ID: <AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 8:26 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> BTW: Do we really need to cleanup initial mapping between _brk_end to _end?
>
> Did you try to revert the patch and run it under your setup?

No.

but it should be ok.

Assume, we can update vmlinux.lds.S to make _end to be 2M aligned as
Stefano suggested?

Yinghai
