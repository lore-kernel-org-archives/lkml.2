Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1CUQl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:41:28 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50998 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753757Ab1CUQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:41:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lVfHOnzqL0u+MLL9KZOnVfS/xI5qGHWMKMgmdL8nxpLHXD87ZxSyj7542karw4+QAjiC7J+lrdGF+Dczway5dIT+in4NJYCjrdmJSxBQwBEko4uU1jgjHTYzPnfuSyCj;
Date: Mon, 21 Mar 2011 09:41:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: rjw@sisk.pl, mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC][PATCH v3 3/3]: PCI: Disable ASPM when _OSC control is not
 granted for PCIe services
Message-ID: <20110321094121.0569e472@jbarnes-desktop>
In-Reply-To: <20110321032516.2353.22321.sendpatchset@nchumbalkar.americas.hpqcorp.net>
References: <20110321032504.2353.59070.sendpatchset@nchumbalkar.americas.hpqcorp.net>
	<20110321032516.2353.22321.sendpatchset@nchumbalkar.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011 03:29:20 +0000 (UTC)
Naga Chumbalkar <nagananda.chumbalkar@hp.com> wrote:

> 
> v3 -> v2: Added text to describe the problem
> v2 -> v1: Split this patch from v1
> v1	: Part of: http://marc.info/?l=linux-pci&m=130042212003242&w=2

Applied this series to my -fixes branch, thanks Naga.

-- 
Jesse Barnes, Intel Open Source Technology Center
