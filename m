Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0GLS1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:27:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59124 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0GLS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Spb5MdYDhQDp3/eqPv87gVBAEGkBij6wFOyiVmN7euxZwtT5sfHES4BGtss6VLgHLj
         hgxC8H1LJkHzOTdheGEYpx4Y2ZtVYQMmIe1Ady1k+ouYC5UhvNDduDc4Ou8UQGGhykf+
         KduaS8yPL7DoCBoEYlKhSJzTwnj2QeT67O1CM=
MIME-Version: 1.0
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C3CFABA@nsmail.netscout.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
	<20100708012120.GB11419@auslistsprd01.us.dell.com>
	<D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
	<82tyo9i0n2.fsf@mid.bfk.de>
	<D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
	<AANLkTik4JOoNFSoML98j8LPJhJjVpWd8om-OYMGp3s9V@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B90C3CF4C5@nsmail.netscout.com>
	<AANLkTilYZTwekbqKCXEaT6Yo3UTDl9tRHJlRdwpSg_IH@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B90C3CFABA@nsmail.netscout.com>
Date: Mon, 12 Jul 2010 11:27:33 -0700
Message-ID: <AANLkTilc6DkjD3Jzqv51t1ohzzxgLqvBZnP4ij3GKekB@mail.gmail.com>
Subject: Re: nic enumeration
From: Steve Fink <sphink@gmail.com>
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Florian Weimer <fweimer@bfk.de>, linux-net@vger.kernel.org,
        Matt Domsch <Matt_Domsch@dell.com>,
        Michael Di Domenico <mdidomenico4@gmail.com>,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I only partially understand your problem, but I am still wondering if
>> my bridge idea would work for you. (Preferably combined with udev
>> rules or whatever so the bridges are unnecessary after the next
>> reboot.)
>
> Why a bridge? Just to get around naming issues?

Yes. I wasn't claiming it was a *good* way to fix it. Just wondering
if it would work.

I have no idea whether it makes sense or not, not really knowing much
about this stuff myself. I tried it on my workstation. It's a good way
to kick yourself off the network. But it does work in the simplest
possible case, if you fix up routing afterwards. I don't know whether
bridges can be usefully used by VMs.
