Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1C2TQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:16:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64570 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1C2TQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pEGydfD67ospQWWUl2eiFpWb9xHCwzg+NfOMmcc2ZiTJFUXC0AdVcdFf3pht28Gn3u
         t44h4xMmhxGVk8NqKNaETd15cH+Y2jDb5c2EFM+QRfYWqf3TlKiCVBADznqR4r6W+Ffm
         Z2/OtSaWXbF+RoyocdJxq9FuZJc/o4GUjma3c=
MIME-Version: 1.0
In-Reply-To: <20110329181524.GA5140@Xye>
References: <20110326224408.GA1336@Xye> <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com> <20110329181524.GA5140@Xye>
From: Michael Witten <mfwitten@gmail.com>
Date: Tue, 29 Mar 2011 14:15:30 -0500
Message-ID: <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 13:15, Raghavendra D Prabhu <rprabhu@wnohang.net> wrote:
> the patch submitted by Michael seems to be taking care of far
> more cases than mine, so that is much better.

One major issue with my current patch is that I opted to stop the
build with an error message even when using the default python command
names; is this undesirable? Is it better to fail silently as before
(via the somewhat cryptic Python.h message), or is it better to force
the user to specify that no python support should be built?
