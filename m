Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1H3Li2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:38:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44927 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1H3LiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:38:25 -0400
Subject: Re: [PATCH] cls_rsvp.h was outdated
From: Eric Dumazet <eric.dumazet@gmail.com>
To: igorm@etf.rs
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <0f79c88be72b75d0526d3f3c2ebf826b.squirrel@kondor.etf.bg.ac.rs>
References: <0f79c88be72b75d0526d3f3c2ebf826b.squirrel@kondor.etf.bg.ac.rs>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 13:38:25 +0200
Message-ID: <1314704305.2935.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 août 2011 à 13:11 +0200, "Igor Maravić" a écrit :
> File cls_rsvp.h in /net/sched was outdated. I'm sending you patch for this
> file.
> Patch was done against Linux 2.6.38-8
> 
> Signed-off-by: Igor Maravić <igorm@etf.rs>
> 
> --- linux-2.6.38.8/net/sched/cls_rsvp.h.orig	2011-08-30 12:46:42.663443918
> +0200

Two last points :

1) Your mail client added line wraps, please take a look at
Documentation/email-clients.txt


> 
>  static struct tcf_proto_ops RSVP_OPS = {
> -	.next		=	NULL,
> +	//.next		=	NULL,
>  	.kind		=	RSVP_ID,
>  	.classify	=	rsvp_classify,
>  	.init		=	rsvp_init,
> 

2) Dont add // comments, just remove the line.

You also could add __read_mostly here :

static struct tcf_proto_ops RSVP_OPS __read_mostly = {


Thanks



