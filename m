Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1C3Px4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:53:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37220 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1C3Pxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kHN0jeoB0kPrgmfna3A8dpOkOfhP92H4TGt64MVQaecwQd2BAtX60QXPamRl0IQyGi
         eMw1AvAPOgxqJcfgyx1xlDDmLnK4nWsV60buOgPP2/QAcwFThgo6t5TUmC0npXTbAXJ+
         IRV/Qy1lr8NfmufwfqMjn0vuWhWmxTtvk4x+s=
Date: Wed, 30 Mar 2011 17:53:50 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Tvrtko Ursulin <tvrtko@ursulin.net>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: 2.6.38 hangs on boot until key is pressed
Message-ID: <20110330155350.GA31845@alberich.amd.com>
References: <1301253485.2500.2.camel@deuteros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301253485.2500.2.camel@deuteros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 08:18:05PM +0100, Tvrtko Ursulin wrote:
> 
> Hi all,
> 
> It always happens at the same spot. 2.6.37 is fine with almost
> identical .config. Dmesg and config attached.


Hi,

can you please send dmesg when 2.6.37 is booted.
Also output of "lspci -nnxxxx" would be of interest.
dmidecode (as root) would also help.

Does it help to disable C1e in your BIOS (if there is such an option)?
If there is no such option please try to boot 2.6.38.1 with idle=mwait
on the command line.


Thanks for now,

Andreas

