Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab0GQA0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab0GQA0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:26:31 -0400
Date: Fri, 16 Jul 2010 18:26:09 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, linux-kbuild@vger.kernel.org,
        nico-linuxsetlocalversion@schottelius.org,
        linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: I did a git pull and a plus appeared
Message-ID: <20100716182609.4cad56e1@lembas.zaitcev.lan>
In-Reply-To: <20100716.131521.55876531.davem@davemloft.net>
References: <20100716121802.65fdfa24@lembas.zaitcev.lan>
	<4C40BAD1.8090908@garzik.org>
	<20100716.131521.55876531.davem@davemloft.net>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 13:15:21 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> It's being put there by Kbuild, this has been discussed quite a bit
> over the past few weeks I think.

I suspected something like that, but finding the relevant discussion
afterwards is different.

> The "+" comes from scripts/setlocalversion

Right, found that quickly, but the question is what the authors' intent was.
I cannot tell from the code. Folks at #kernel seem to think the plus means
"built from a tarball", in which case this is a bug (the kernel was built
from a cloned tree).

I can easily add '+' to the list of filename characters in my terminal,
just thought to ask in case it's a bug.

-- Pete
