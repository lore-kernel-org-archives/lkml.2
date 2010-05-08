Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0EHWoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 18:44:38 -0400
Received: from mail.perches.com ([173.55.12.10]:2064 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab0EHWoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 18:44:37 -0400
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by
 default
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
In-Reply-To: <1273354778-6129-1-git-send-email-florian@mickler.org>
References: <1273354364-6016-1-git-send-email-florian@mickler.org>
	 <1273354778-6129-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 15:44:34 -0700
Message-ID: <1273358674.704.77.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 23:39 +0200, florian@mickler.org wrote:
> If scm meta-information is used, only list people that signed-off or
> acked or reviewed the code in question.
> 
> after all it's called get_maintainer.pl and not
> get_random_people_to_look_at_the_code.pl

Anyone that actually signs a patch is not "random".


