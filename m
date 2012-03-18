Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2CRVks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 17:40:48 -0400
Received: from cet.com.ru ([195.178.208.66]:52101 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752433Ab2CRVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 17:40:47 -0400
Date: Mon, 19 Mar 2012 01:40:41 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120318214041.GA20521@ioremap.net>
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63AF9E.2090000@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Mar 16, 2012 at 10:24:46PM +0100, Markus Franke (markus.franke@s2002.tu-chemnitz.de) wrote:
> This patch adds a 1-wire slave device driver for the DS28E04-100.
> 
> It applies to the current linux kernel git tree.

As discussed with Markus already - looks very good
Greg, please pull it into your tree

> Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
