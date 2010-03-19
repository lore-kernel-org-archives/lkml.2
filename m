Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0CSUqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:46:08 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:42822 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751397Ab0CSUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:46:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VdVxB6A1LcCwRAS4VnyYqfJfEodqilUFVn58HKl2UjqctYU8PyGWotYPXCaV9ppXXa29m9/j85Zmm7yu11SpCfTvue8RBEnJRH0Z7VPjDTmoxN6jqRF0QdBU4qdmvxJN;
Date: Fri, 19 Mar 2010 13:46:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Subject: Re: [PATCH v1 1/3] resources: add interfaces that return conflict
 information
Message-ID: <20100319134606.20f5427a@jbarnes-piketon>
In-Reply-To: <20100312000108.4355.47777.stgit@bob.kio>
References: <20100311235954.4355.23100.stgit@bob.kio>
	<20100312000108.4355.47777.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 17:01:09 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> request_resource() and insert_resource() only return success or failure,
> which no information about what existing resource conflicted with the
> proposed new reservation.  This patch adds request_resource_conflict()
> and insert_resource_conflict(), which return the conflicting resource.
> 
> Callers may use this for better error messages or to adjust the new
> resource and retry the request.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
> 

Applied this series to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
