Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1GFRtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:49:06 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:43625 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754844Ab1GFRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:49:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sIEfwlK+IhCYn649/1+iiUEB+maCHa3qwJOAh+6rq+ju5Hf2/L0H2Dl6BJ0qfvm7G0LnjVNXkWth3YiDmfNJ28MK6RZwgcyavb9D4O4NJ1/AT7WEYlTNz7MjM56nePft;
Date: Wed, 6 Jul 2011 10:48:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Ram Pai <linuxram@us.ibm.com>, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 3/5 v2] PCI: make SRIOV resources optional
Message-ID: <20110706104848.7e9d21fc@jbarnes-desktop>
In-Reply-To: <4E0D62BD.5070405@hartkopp.net>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
	<1309477662-18680-4-git-send-email-linuxram@us.ibm.com>
	<4E0D62BD.5070405@hartkopp.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jul 2011 08:01:33 +0200
Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> On 01.07.2011 01:47, Ram Pai wrote:
> > From: Yinghai Lu <yinghai@kernel.org>
> > 
> > From: Yinghai Lu <yinghai@kernel.org>
> > 
> > Allocate resources to SRIOV BARs only after all other required
> > resource-requests are satisfied. Dont retry if resource allocation for SRIOV
> > BARs fail.
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> I applied the whole patchset and it looks very similar to the dmsg output
> before the problematic commit that caused the regression.

Ok Oliver, can I ask you to test one more tree?  We'll shoot for
including Ram's patches in -next, but I've just included his other
patch to disable the new realloc code by default for the current
kernel.  Can you give my for-linus tree a try and make sure it gives
you back the old behavior?  Thanks a lot for your diligent testing so
far.

git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 is the
tree, then check out the "for-linus" branch.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
