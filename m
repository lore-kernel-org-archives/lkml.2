Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0C2Xdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:33:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1244 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab0C2Xdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:33:46 -0400
Subject: Re: [PATCH 2/2] ath: fix macros coding style issue in regd.c
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luisbg@ubuntu.com>
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1269904339-15599-1-git-send-email-luisbg@ubuntu.com>
References: <regd.c>  <1269904339-15599-1-git-send-email-luisbg@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:33:44 -0700
Message-ID: <1269905624.4558.56.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 00:12 +0100, Luis de Bethencourt wrote:
> This is a patch to the ath/regd.c file that fixes up three warnings
> about macros found by the checkpatch.pl tool, these said that
> complex values should be enclosed in parenthesis.

Hi Luis.

Checkpatch isn't always correct.

Please make sure to compile test your changes
before submitting them.

These macros are used as initializers and
can not be surrounded by parentheses.

	.reg_rules = {
		ATH9K_2GHZ_ALL,

cheers, Joe

