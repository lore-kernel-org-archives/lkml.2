Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0ERWHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:07:16 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45358 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754234Ab0ERWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:07:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kUxbxcuKTQQwF0ZUHk6NBPGIhICZaWh+uAPurl8+5xXzywH3XWANOndiulFOn3rJ1u9znGnfk1gd9oEABrguJ84mXudbsNL3pNX7juPOVtc1Nh3+yiPDfxQbz2avtSwC;
Date: Tue, 18 May 2010 15:05:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 17/37] drivers/pci/hotplug: Use kmemdup
Message-ID: <20100518150551.3499b753@virtuousgeek.org>
In-Reply-To: <Pine.LNX.4.64.1005152318000.21345@ask.diku.dk>
References: <Pine.LNX.4.64.1005152318000.21345@ask.diku.dk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010 23:18:16 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
