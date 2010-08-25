Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0HYTy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:54:26 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:42351 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753132Ab0HYTyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:54:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=g/aeth1cvOxn/fSRzLHvs3g4nuiJBgeACpYMm5UjA01zHw7CjHItUxUPW8oFnAoVXBhdE5HpWiuCcg25lgFSZP/0oZj3jGvK7Py/QfhuzEB9io533SJwNYXcxDDqGSEp;
Date: Wed, 25 Aug 2010 12:54:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (pci-current tree related)
Message-ID: <20100825125420.78d63e37@virtuousgeek.org>
In-Reply-To: <201008252133.29525.rjw@sisk.pl>
References: <20100825115604.07928f97.sfr@canb.auug.org.au>
	<201008252133.29525.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 21:33:29 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Subject: PCI / hot-plug: Fix build with CONFIG_ACPI unset
> 
> One of the recent changes caused complilation of
> drivers/pci/hotplug/pciehp_core.c to fail.  Fix this issue.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Fix pushed out to my for-linus branch, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
