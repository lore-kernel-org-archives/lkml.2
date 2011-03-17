Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1CQX4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:56:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48792 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1CQX4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=dY4QUKEaCslpYJUo+kO8RXoMkghqLsWmku5FqQryutxx63WKSZr+NfVzuMasF5k2dD
         AXpkosXO271a0yI4EJDyV2ml0Dr5O39WNQlZaA4IhwWcocTC4wCjZeEFo9l2UMjSHY8k
         eu+AtAdOOTfWn655ZRdzLMjhdCqQZURM9DOz0=
MIME-Version: 1.0
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC10249@orsmsx501.amr.corp.intel.com>
References: <20110318100418.6556c92c.sfr@canb.auug.org.au> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC10249@orsmsx501.amr.corp.intel.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 17 Mar 2011 16:56:27 -0700
X-Google-Sender-Auth: 3PvW0fedPVXO322oD13XCXtQvdA
Message-ID: <AANLkTikB=ZQQG18sDbD2kfFMWdVuUqnzYWOf7KtuBKVc@mail.gmail.com>
Subject: Re: [PATCH] rdma/addr: Initialize ret to fix build warning
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        Changli Gao <xiaosuo@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 4:35 PM, Hefty, Sean <sean.hefty@intel.com> wrote:
> Commit b23dd4fe42b455af5c6e20966b7d6959fa8352ea (ipv4: Make output
> route lookup return rtable directly) resulted in leaving
> ret uninitialized, where it may later be returned.

Looks good to me, I'll merge this.
