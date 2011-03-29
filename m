Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab1C2VCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:02:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52939 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1C2VCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=HB0+8KUINE89EsHsvD+7Bx/3vuMHzrUVuKm0VWxeU9s1OVyc1whUPZ0WxOPSozSG2J
         jebjkY2Io3GZ2pVAGoCxeoOqRCRvRJvX3hyhJNV9Fpa/vIrkulAr39KqPHNUwwVnU2pg
         0NE52gPxwOWvbhFdEVqhAUEGemCibv8LrCztM=
MIME-Version: 1.0
In-Reply-To: <20110329204024.GA20824@ghostprotocols.net>
References: <20110326224408.GA1336@Xye> <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com> <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com> <20110329204024.GA20824@ghostprotocols.net>
From: Michael Witten <mfwitten@gmail.com>
Date: Tue, 29 Mar 2011 16:02:07 -0500
Message-ID: <AANLkTinmXdmNX+iCB4svo3QqR6AcwGrasziFJPeu0J=M@mail.gmail.com>
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 15:40, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> I think that the best course of action is to emit a warning and go

Good.

I'll make it so!
