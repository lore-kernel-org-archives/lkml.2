Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab0GWR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:28:42 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:36065 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754246Ab0GWR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:28:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WeuvRNLiOGFtpiJr5ZRd+ADt8gPX8CnFT+ICU/SB4VZQQn8QzASfR+TlIlLWWxuK8KtlmlkXEKtlvDcUlujcCWtcm0ho7xF2LESbSR35Q8MzrD5OJxDIjK2Jw/gjlUc4;
Date: Fri, 23 Jul 2010 10:28:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend
 Lenovo W500 laptop
Message-ID: <20100723102849.54bbc281@virtuousgeek.org>
In-Reply-To: <123290.24094.qm@web88006.mail.re2.yahoo.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
	<tneGvaw1wLL.A.OLB.i3XSMB@chimera>
	<123290.24094.qm@web88006.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 07:11:34 -0700 (PDT)
Shawn Starr <shawn.starr@rogers.com> wrote:

> 
> 
> Still continues. I can however hibernate and resume from hibernation ok.
> 

If it works on Fedora, maybe you could get it working with a similar
upstream kernel (same version, same config) and then bisect?

-- 
Jesse Barnes, Intel Open Source Technology Center
