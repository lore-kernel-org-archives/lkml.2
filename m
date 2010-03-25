Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0CYSVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:21:33 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:32921 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753912Ab0CYSVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:21:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jGOOo1V3ir16GO0HeCNM9UOyuGXW/nDYodVJOiPqCArSBgsYBBJd/GnQxCV2bcrAqV3QmuZrT9HnWyk48+XSDrZjjhsg9DGSdyjC9kQeADwJemKXxprMTnDUr+VArolP;
Date: Thu, 25 Mar 2010 11:20:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Subject: Re: [PATCH 1/2] x86/PCI: for host bridge address space collisions,
 show conflicting resource
Message-ID: <20100325112056.1af959ab@jbarnes-piketon>
In-Reply-To: <20100325152824.10117.37931.stgit@bob.kio>
References: <20100325152750.10117.81615.stgit@bob.kio>
	<20100325152824.10117.37931.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 09:28:24 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> With insert_resource_conflict(), we can learn what the actual conflict is,
> so print that info for debugging purposes.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Pushed these two to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
