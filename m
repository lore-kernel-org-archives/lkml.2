Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0IBNRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:17:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33807 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0IBNRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mxwUpmD0Stkgvs7VISZkutb3EMm76SSbThb1yrpR9ge3MJ5NdpfU2XJtJ0L5jYreGK
         0TtQbV6u9Fo3Hn+GaZamQqpDCoxMrRNDD2ePV+llbknihSzgXyTiMFjr14dJQyL6rdXu
         iyrJpKuYyqvm91afSzcWwdN4xrcjNsjWtkTVE=
MIME-Version: 1.0
In-Reply-To: <20100902105229.GI2406@shadowen.org>
References: <20100818204016.GA29640@redhat.com>
	<1282167133.6724.165.camel@Joe-Laptop>
	<20100818214818.GA31094@redhat.com>
	<1282168679.6724.174.camel@Joe-Laptop>
	<20100818221721.GA2667@redhat.com>
	<1282174721.6724.202.camel@Joe-Laptop>
	<20100902105229.GI2406@shadowen.org>
Date: Thu, 2 Sep 2010 13:17:45 +0000
Message-ID: <AANLkTimU81+SaHMF7LQf-baDor3nOQgaNjDGhfrJCwqS@mail.gmail.com>
Subject: Re: add memset checks to checkpatch.pl
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 10:52, Andy Whitcroft <apw@canonical.com> wrote:

> [...] /^(0x|)0$/i

The canonical way to write this is using curlies:

/^(0x)?0$/i
