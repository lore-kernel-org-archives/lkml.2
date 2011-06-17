Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab1FQMMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 08:12:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62135 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab1FQMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 08:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Irx+LbjgkBvJe1Fb43tonFy1g4CPb8JnVHx70eVkVJHBgtNZQf/APDtb4PoDUiRGiA
         F++g+ZGVaa8gju+rZa+UGTb9rEEME4RdkUqZq8CmGsBAw7NEawQijvJjh36S16rfqH0p
         2K+UzV3s1PiG46VawCSwK0IT7thi3G+0FAOPg=
MIME-Version: 1.0
In-Reply-To: <BANLkTin9NXs1M9ud9Kqtp9cKGzY6AKnMpQ@mail.gmail.com>
References: <BANLkTin9NXs1M9ud9Kqtp9cKGzY6AKnMpQ@mail.gmail.com>
Date: Fri, 17 Jun 2011 08:12:12 -0400
Message-ID: <BANLkTinqxc868E2H1LxeFbsAsdHg2dLNjA@mail.gmail.com>
Subject: Re: Please help us resolve the shutdown problem that is affecting our computers
From: Diego Viola <diego.viola@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any idea please?

On Fri, Jun 17, 2011 at 1:00 AM, Diego Viola <diego.viola@gmail.com> wrote:
> Hello,
>
> We are currently experiencing an issue that affects the shutdown process.
>
> The problem occurs when we shutdown our machines, the system would
> lock/hang during the shutdown process with a message similar to:
> "Disabling IRQ #19.".
>
> I send this email to the mailing list, hoping to get the attention of
> a knowledgeable maintainer in order to fix this issue, which is
> affecting not only me but many people. I already have started a thread
> in bugzilla, but we haven't received many responses from developers.
>
> The link to the bug report is:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=33872
>
> We are able to reproduce the issue and the problem goes away on my
> machine if I unload the 'e1000e' module before shutdown. This
> workaround has worked for other people also, but I don't consider it
> to be a real fix. There's also other people who have different
> hardware and don't have this 'e1000e' module loaded at all and yet
> they also experience shutdown hangs. How can this be explained?
>
> Please help us to resolve this issue. We would happily assist in order
> to test proposed patches, etc. We just want to get this problem fixed.
>
> Thanks,
> Diego Viola
>
