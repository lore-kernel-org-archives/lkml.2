Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2JFVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 17:09:28 -0400
Received: from mail.southpole.se ([193.12.106.18]:60661 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2JFVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 17:09:27 -0400
Message-ID: <1349557763.25406.7.camel@jerome.southpole.se>
Subject: Re: [GIT PULL] Disintegrate UAPI for openrisc
From: Jonas Bonn <jonas@southpole.se>
To: David Howells <dhowells@redhat.com>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Sat, 06 Oct 2012 23:09:23 +0200
In-Reply-To: <17392.1349380295@warthog.procyon.org.uk>
References: <17392.1349380295@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 57764-07246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 2012-10-04 at 20:51 +0100, David Howells wrote:
> Can you merge the following branch into the openrisc tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Note that there are some fixup patches which are at the base of the branch
> aimed at you, plus all arches get the asm-generic branch merged in too.

I gave this a try and it all looks good for OpenRISC.  I'll be happy, in
principle, to push this for 3.7... but it's a bit disconcerting that
there's a bunch of stuff here that shouldn't be going via the OpenRISC
tree.  Any chance you could give a heads-up when everything up to the
'disintegrate-openrisc' commit has been merged upstream so that I don't
end up asking Linus to pull stuff outside of the arch/openrisc
directory?

Thanks,
Jonas


