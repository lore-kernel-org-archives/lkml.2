Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138Ab0FRRSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:18:53 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44614 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757794Ab0FRRSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:18:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=n+yRWK1HSIS99sbfMNEIi99pxzQn79rxz9mCT1J+DF0ne8cqYeI9GMXGkzThtxN72K2wcApsb9zgXPTQ/myWTc2DYCtU2+yq29qGU7+vf91mizw4GO5jdDut3Od6liTi;
Date: Fri, 18 Jun 2010 10:17:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frank Pan <frankpzh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a helper function in PCI IOV to get VF device
Message-ID: <20100618101714.15146089@virtuousgeek.org>
In-Reply-To: <AANLkTil74rKaddoYKj-zuEjfl0cKT8uyofjH9wZ0zFOf@mail.gmail.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
	<20100608143514.740f8095@virtuousgeek.org>
	<AANLkTil74rKaddoYKj-zuEjfl0cKT8uyofjH9wZ0zFOf@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 15:42:12 +0800
Frank Pan <frankpzh@gmail.com> wrote:

> > Per the discussion in this thread it sounds like this really has
> > nothing to do with sysfs and more to do with being a convenient API for
> > drivers.
> Yes.
> 
> > Is that correct?  If so, and assuming there's not some other way of
> > getting this info from a driver, I'm ok with it, but it should be
> > submitted as part of a patchset including driver code that uses it.
> Yes, I may submit them all after the driver hack is complete. I put the
> issue here to get response of some thing like, is this change possible?
> or is there a better way to do it?
> 
> Thanks for reply.

I think once we see the driver usage it'll be easier to say.

Chris is the one you'll need to convince though.

-- 
Jesse Barnes, Intel Open Source Technology Center
