Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0KOLbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:31:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61184 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0KOLbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EaL/JmAAmCat1QsKTucC/oBuZ9pE+GZ4h0xyf3E+CESLicLkeBhagfE0yq3G3Bd5eZ
         31rgMNYFxttYidFEJs3iez456+IogNJMvoVM7LFdXSINjwsYEAZN55jectmIK3JkL06k
         qpD/Adoyc8lxwLAOcxLaKxIwUh1RK6WEMRjjY=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTinzRm_5WW5HwxzXqZZD4255GDpR4yzELqz66Dfn@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	 <4CDF1945.8090101@tilera.com>
	 <AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
	 <AANLkTinzRm_5WW5HwxzXqZZD4255GDpR4yzELqz66Dfn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 12:31:12 +0100
Message-ID: <1289820672.2607.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 novembre 2010 à 19:18 +0800, Cypher Wu a écrit :
> In that post I want to confirm another thing: if we join/leave on
> different cores that every call will start the timer for IGMP message
> using the same in_dev->mc_list, could that be optimized?
> 

Which timer exactly ? Is it a real scalability problem ?

I believe RTNL would be the blocking point actually...



