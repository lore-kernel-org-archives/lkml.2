Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0HMXch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:32:37 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:56664 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755444Ab0HMXcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:32:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hTH2Bp3yUgod/+HSz0LUQDFroujrweTFKxhQ4G58KV9SLwgg0NR0LyBnwN2+wIf6Pat5i8bVFKuC5PknhEhLgkgwRRfOD9lmj4WuubKP9jJR6O3wnOEX0WW8R97zWntH;
Date: Fri, 13 Aug 2010 16:32:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 21/42] drivers/pci: Adjust confusing if indentation
Message-ID: <20100813163232.56f93c28@virtuousgeek.org>
In-Reply-To: <Pine.LNX.4.64.1008052223010.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052223010.31692@ask.diku.dk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010 22:23:16 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Indent the branch of an if.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
