Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1JISCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 14:02:01 -0400
Received: from void.printf.net ([89.145.121.20]:43873 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1JISB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 14:01:58 -0400
From: Chris Ball <cjb@laptop.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Per Forlin <per.forlin@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
References: <20110928181815.45f540034ddde2b206fc4e57@canb.auug.org.au>
	<20111009050809.GS19986@windriver.com>
Date: Sun, 09 Oct 2011 14:01:27 -0400
In-Reply-To: <20111009050809.GS19986@windriver.com> (Paul Gortmaker's message
	of "Sun, 9 Oct 2011 01:08:09 -0400")
Message-ID: <m2pqi6m4co.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, Oct 09 2011, Paul Gortmaker wrote:
> I was wondering if you were going to apply this to the mmc tree.  Since
> the module_param addition isn't in the module.h baseline, I'd be
> speculatively fixing an issue that hasn't been created yet, which isn't
> the end of the world, but it doesn't feel quite right to do that either.

Thanks, I've pushed both this patch and "Add module.h to drivers/mmc
users assuming implicit presence" to the mmc-next tree now.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
