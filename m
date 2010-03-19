Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0CSGwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:52:23 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:38945 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0CSGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=twMgCRfyb+r97My717EcK0rGqLbf6Z1j+hE2c7KcBGp8hdThxyQIupX0xvqU4XdPYZ
         Vux7vu/wix51UjrLxYuIJkEMy+e0zW1VWQWhJBkBWT/AsVPIGCvTSTsvl96HXA3hSGp/
         JIoAvA0yEWdDrSRfi5HgNHWSctEldqm9bC+fg=
MIME-Version: 1.0
In-Reply-To: <20100319031850.GB3137@localhost.localdomain>
References: <20100319031850.GB3137@localhost.localdomain>
Date: Fri, 19 Mar 2010 08:52:21 +0200
Message-ID: <b6fcc0a1003182352t2bef04f6k2c4c64f539b802c0@mail.gmail.com>
Subject: Re: [PATCH] Netfilter: Remove unused headers in net/ipv6/netfilter/ip6t_LOG.c
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       kaber@trash.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 5:18 AM,  <wzt.wzt@gmail.com> wrote:
> Remove unused headers in net/ipv6/netfilter/ip6t_LOG.c

It'd be better to search whole tree and send one patch
that send one by one.
