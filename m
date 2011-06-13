Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1FMSgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:36:08 -0400
Received: from mail.perches.com ([173.55.12.10]:2850 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1FMSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:36:05 -0400
Subject: Re: [PATCH v2] coccinelle: if (ret) return ret; return ret;
 semantic patch
From: Joe Perches <joe@perches.com>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
In-Reply-To: <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
	 <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 11:36:04 -0700
Message-ID: <1307990164.26699.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 13:23 -0500, Greg Dietsche wrote:
> Semantic patch to find code that matches this pattern:
[]
> diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
[]
> +-if (ret > operand) return ret;
> +|
> +-if (ret < operand) return ret;

Maybe add <= and >=

