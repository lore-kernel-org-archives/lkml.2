Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0KLJWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:22:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63117 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0KLJWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ezqkx32e/VaMCAo/OkmSbwhOIb0R0Rorz63i73wBXslULD9LOHEXLK1tJSEnCYu6eD
         LmXNHMNf9tqOVUeUDYKNr6bKEy3HAOMhY/LKYrgaw5qf0U1EgUtIvbIBtjjaC0aHYIpB
         HwJlBOzFa2i153n7LULcTIGGct3f9myfzDUb0=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Cypher Wu <cypher.w@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20101112081945.GA5949@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <20101112071323.GB5660@cr0.nay.redhat.com>
	 <1289546874.17691.1774.camel@edumazet-laptop>
	 <20101112081945.GA5949@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 10:22:39 +0100
Message-ID: <1289553759.3185.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 16:19 +0800, Américo Wang a écrit :
> On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:

> >A RCU conversion is far more complex.
> >
> 
> Yup.


Well, actually this is easy in this case.

I'll post a patch to do this RCU conversion.



