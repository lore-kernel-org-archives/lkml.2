Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0IWUu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:50:28 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:54179 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755358Ab0IWUu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:50:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=id9ldDUY+CafyKYse4+qmVBvDVro0BuOyEGkB59g5GeUZ2+K7eDhyPNlcjGTNmjsPSGF2rjt9eEy/KTyLKeDuNviuS2TgGZthiJtW5PY1vZ+hyAQhVSCvsv3aYNhu7VR;
Date: Thu, 23 Sep 2010 13:50:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joe Perches <joe@perches.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
Message-ID: <20100923135023.39febc7e@jbarnes-desktop>
In-Reply-To: <1285274825.25928.19.camel@Joe-Laptop>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	<4C770299.6000708@cesarb.net>
	<1282869660.1836.5.camel@Joe-Laptop>
	<4C77171E.6060008@cesarb.net>
	<1282894751.1836.41.camel@Joe-Laptop>
	<4C784650.2030200@cesarb.net>
	<1282962104.1946.179.camel@Joe-Laptop>
	<20100923133132.3faae5b3@jbarnes-desktop>
	<1285274825.25928.19.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 13:47:05 -0700
Joe Perches <joe@perches.com> wrote:

> On Thu, 2010-09-23 at 13:31 -0700, Jesse Barnes wrote:
> > I think the programmed limits are valid if they're nonzero and less
> > than one of the available default limits.  If they're not valid, we
> > should just use the default values.  I was thinking something like the
> > below for MCP, but Joe you may want to just update your patch instead
> > since it's more complete.
> 
> You have my patch yes?
> 
> You can probably integrate and validate it
> better than I can with your proposed change.
> 
> I don't have any of the hardware to test.
> If I can otherwise help somehow, let me know.

Ah ok, I'll fix it up and respin then, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
