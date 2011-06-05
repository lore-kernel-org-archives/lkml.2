Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1FEH7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:59:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64762 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab1FEH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AvOWaB4bQBd5fGQIe9Vs+ANtJdUCq/AT9DMxpFLbro6tzseNxbn6/ZvIc4jMj1Ksev
         ZlGuz/iGVKiLT0L5Yz8xth3Cr9zYBGSFiinLdpNVoooEijG/3DZLaaBMQfIXM7Zsu33Q
         M8PIQYQQwOzkcgj4AM7KalrgndthqUgCm4U08=
MIME-Version: 1.0
In-Reply-To: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
References: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
Date: Sun, 5 Jun 2011 17:59:37 +1000
Message-ID: <BANLkTin4tWcJ-6Yjh_Yg18dNXNpiXjRA3A@mail.gmail.com>
Subject: Re: [PATCH 00/10] staging/mei: Intel MEI Driver
From: Dave Airlie <airlied@gmail.com>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se, tomas.winkler@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 8:43 PM, Oren Weil <oren.jer.weil@intel.com> wrote:
> Intel MEI Driver
> ===============
>
> This second try to submit the Intel MEI Driver to the staging.
> Most of the work was done in mei.txt file to describe the driver
> functionality and flows.
> TODO file was updated with steps we believe need to be done.
> We also hope that patches have better descriptions to help with review.
> Some reorganization of header files was also preformed.

Hi guys,

this device takes over the PCI driver for the host bridge, which stops
the AGP driver from
loading which stops i915 from loading, which makes things sad.
Hopefully that is another
TODO on the list if it isn't already on it.

I enabled it by mistake and then wondered what was going on.

I think EDAC used to suffer from this issue as well.

Dave.
