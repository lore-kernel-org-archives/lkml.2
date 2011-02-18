Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab1BRTOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:14:24 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41383 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab1BRTOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oBVGe2sOJALHUUoD03xg3KQB7L3SC5c3bzfqoAJofQXMnVBiQy2MKNt4N7sGTy837Z
         1Hz1ykcOV6zINerLyLa5CecKLjckhjnO4tU4Nmrwnnijp5hf22WsaNiH7zK7+puPmpHA
         pXgZLAqZuU+ZbhXj/Xb52foEsUFrufg/wTbjc=
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
In-Reply-To: <20110218190128.GF13211@ghostprotocols.net>
References: <20110217090910.GA3781@tiehlicka.suse.cz>
	 <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	 <20110218122938.GB26779@tiehlicka.suse.cz>
	 <20110218162623.GD4862@tiehlicka.suse.cz>
	 <AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
	 <m17hcx43m3.fsf@fess.ebiederm.org>
	 <AANLkTikh4oaR6CBK3NBazer7yjhE0VndsUB5FCDRsbJc@mail.gmail.com>
	 <20110218190128.GF13211@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 20:13:49 +0100
Message-ID: <1298056429.2425.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 février 2011 à 17:01 -0200, Arnaldo Carvalho de Melo a
écrit :

> Original code is ANK's, I just made it possible to use with DCCP, and
> yeah, the smiley is appropriate, something 6 years old and the world
> around it changing continually... well, thanks for the git blame ;-)
> 

At that time, net namespaces did not exist.

I would blame people implementing them ;)



