Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1EXFyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:54:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1921 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1EXFym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:54:42 -0400
Subject: Re: [PATCH v2]net:8021q:vlan.c Fix pr_info to just give the vlan
 fullname and version.
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>
In-Reply-To: <1306215958.2638.29.camel@edumazet-laptop>
References: <1306215647-2857-1-git-send-email-justinmattock@gmail.com>
	 <1306215958.2638.29.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 22:54:40 -0700
Message-ID: <1306216480.2298.1.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 07:45 +0200, Eric Dumazet wrote:
> Le lundi 23 mai 2011 à 22:40 -0700, Justin P. Mattock a écrit :
> > The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init, 
> > so that it prints out just the fullname of vlan and the version number.
[]
> > diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> > -	pr_info("%s v%s %s\n", vlan_fullname, vlan_version, vlan_copyright);
> > -	pr_info("All bugs added by %s\n", vlan_buggyright);
> > +	pr_info("%s v%s\n", vlan_fullname, vlan_version);
> >  
> >  	err = register_pernet_subsys(&vlan_net_ops);
> >  	if (err < 0)
> This reminds me a discussion with Harald Welte in netfilter workshop
> 2010.
> Sometime these strings help lot guys working to fight GPL violations.

How so?


