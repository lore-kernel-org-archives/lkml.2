Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0K2Xdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:33:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50735 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab0K2Xdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:33:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=GN1bi1h-fx0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=werjbqos1wF7NX3V4TgA:9 a=8KrLOPV6pAeZU35X0fD7cAlMBgAA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd] kvm: don't warn on new fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <1291051539-16791-1-git-send-email-avi@redhat.com>
References: <1291051539-16791-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 29 Nov 2010 18:33:40 -0500
Message-ID: <1291073621.30543.880.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 19:25 +0200, Avi Kivity wrote:
> The kvm plugin understands a few new fields; don't warn if they are missing,
> as expected on older kernels.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  plugin_kvm.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Applied, Thanks Avi!

-- Steve


