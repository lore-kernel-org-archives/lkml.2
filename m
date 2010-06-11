Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0FKHmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:42:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33049 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0FKHmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tBWjFZ0fU9Z79qS+00Gi032/cZtP9NdG2R7Iw8kwAy0FklFZnoDaauueNoG+9/fFSU
         6tu10tI8KtPsvPiJxZWwfcIjG/dVNZ+pRv9/CmH3JTldG1+IsNumi8wqad9giYgB3dkJ
         amzP2ZO91nBFM3/qHldkDjUTpJryZhuwdMNMM=
MIME-Version: 1.0
In-Reply-To: <20100608143514.740f8095@virtuousgeek.org>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100608143514.740f8095@virtuousgeek.org>
From: Frank Pan <frankpzh@gmail.com>
Date: Fri, 11 Jun 2010 15:42:12 +0800
Message-ID: <AANLkTil74rKaddoYKj-zuEjfl0cKT8uyofjH9wZ0zFOf@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Per the discussion in this thread it sounds like this really has
> nothing to do with sysfs and more to do with being a convenient API for
> drivers.
Yes.

> Is that correct?  If so, and assuming there's not some other way of
> getting this info from a driver, I'm ok with it, but it should be
> submitted as part of a patchset including driver code that uses it.
Yes, I may submit them all after the driver hack is complete. I put the
issue here to get response of some thing like, is this change possible?
or is there a better way to do it?

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
