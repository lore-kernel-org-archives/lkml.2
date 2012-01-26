Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2AZXHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:07:06 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35752 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2AZXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:07:04 -0500
Date: Thu, 26 Jan 2012 18:07:01 -0500 (EST)
Message-Id: <20120126.180701.25705416327084792.davem@davemloft.net>
To: dmitry.kasatkin@intel.com
Cc: sparclinux@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Fix multiple definitions of clz_tab
From: David Miller <davem@davemloft.net>
In-Reply-To: <CALLzPKYnqdYfXHUzH+OTr+fv2Y3VBOjjYdSTOtn4HkPvuB7eXw@mail.gmail.com>
References: <20120126.173205.137498840079872845.davem@davemloft.net>
	<CALLzPKYnqdYfXHUzH+OTr+fv2Y3VBOjjYdSTOtn4HkPvuB7eXw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 15:07:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Date: Fri, 27 Jan 2012 01:02:08 +0200

> How should I deal with your patches?
> I send patches via LSM list. James Morris applies them.
> Should I re-send them along with my patches?

I have no opinion on this, feel free to submit them directly
if you wish.
