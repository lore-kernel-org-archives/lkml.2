Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab1DHTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:50:30 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:41958 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757835Ab1DHTu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:50:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nuN9LGSzJa8nGSI/DRtn1h+1oLrQeiizBWyy4Jxukh5UmdThfA/OiDZWtqkqMpgSjyGtux1QdoQiv9OH5CFB3tGHUI68u5rCLwvBaF9xlKlsgVLtiiV3AgDDSii6nv5N;
Date: Fri, 8 Apr 2011 12:50:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel-janitors@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] arch/x86/pci/direct.c: Convert release_resource to
 release_region/release_mem_region
Message-ID: <20110408125018.49c6860f@jbarnes-desktop>
In-Reply-To: <1297599132-7226-5-git-send-email-julia@diku.dk>
References: <1297599132-7226-1-git-send-email-julia@diku.dk>
	<1297599132-7226-5-git-send-email-julia@diku.dk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011 13:12:11 +0100
Julia Lawall <julia@diku.dk> wrote:

> Request_region should be used with release_region, not release_resource.
> 
> The local variables region and region2 are dropped and the calls to
> release_resource are replaced with calls to release_region, using the first
> two arguments of the corresponding calls to request_region.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
