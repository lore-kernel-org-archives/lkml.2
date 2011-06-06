Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1FFUXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:23:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63735 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab1FFUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eqtp4tTQjRd9/DnJtztStpp+Y5LjVI7Po7l2rr13PB6jVCY2ogc9wBawWJ23t6mhgi
         qZJwSTT27LkBlMk5zhEBVP8SIN88KQM6bx2Zbsy58W1XI4Kqdpp6wMvXyn/03LwT4Cjz
         gt69spdPBV6NULHtvix4iQc6PSlyu0DQNcQ6U=
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bart De Schuymer <bdschuym@pandora.be>
Cc: Brad Campbell <brad@fnarfbargle.com>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
In-Reply-To: <4DED344D.7000005@pandora.be>
References: <20110601011527.GN19505@random.random>
	 <alpine.LSU.2.00.1105312120530.22808@sister.anvils>
	 <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com>
	 <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com>
	 <4DE60940.1070107@redhat.com> <4DE61A2B.7000008@fnarfbargle.com>
	 <20110601111841.GB3956@zip.com.au> <4DE62801.9080804@fnarfbargle.com>
	 <20110601230342.GC3956@zip.com.au> <4DE8E3ED.7080004@fnarfbargle.com>
	 <isavsg$3or$1@dough.gmane.org> <4DE906C0.6060901@fnarfbargle.com>
	 <4DED344D.7000005@pandora.be>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 22:23:17 +0200
Message-ID: <1307391797.2642.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 22:10 +0200, Bart De Schuymer a écrit :
> Hi Brad,
> 
> This has probably nothing to do with ebtables, so please rmmod in case 
> it's loaded.
> A few questions I didn't directly see an answer to in the threads I 
> scanned...
> I'm assuming you actually use the bridging firewall functionality. So, 
> what iptables modules do you use? Can you reduce your iptables rules to 
> a core that triggers the bug?
> Or does it get triggered even with an empty set of firewall rules?
> Are you using a stock .35 kernel or is it patched?
> Is this something I can trigger on a poor guy's laptop or does it 
> require specialized hardware (I'm catching up on qemu/kvm...)?
> 

Keep netdev, as this most probably is a networking bug.



