Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0KDDjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:39:03 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:43740 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab0KDDjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:39:00 -0400
Message-ID: <4CD22ACF.1000407@asbjorn.it>
Date: Thu, 04 Nov 2010 03:38:55 +0000
From: =?ISO-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <asbjorn@asbjorn.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
References: <4CD20F85.7040005@asbjorn.biz> <1288838560-6173-1-git-send-email-asbjorn@asbjorn.biz>
In-Reply-To: <1288838560-6173-1-git-send-email-asbjorn@asbjorn.biz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 02:42 AM, Asbjoern Sloth Toennesen wrote:
> +			case "$SUBARCH" in
> +				arm) debarch=$(grep -q CONFIG_AEABI=y .config \
> +						&& echo armel || echo arm) ;;
> +			esac

Hmm, didn't test the ARM part of that patch properly SUBARCH isn't
available to builddeb. Will reply to this mail with fixed patch.
