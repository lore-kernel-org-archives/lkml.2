Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1AGW2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:28:01 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45417 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755021Ab1AGW17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:27:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ifinbr8RD1UIv1q6fKW85rO94cJxWg9KC3AIfjNNr9x/SHhqqMjv6uFejfR8OsUY0Ok4auq7/d5L/hvovyy5iQTe3TEKl2OwSA8s25jUraJrpJgVX4KhDcj+/YJRR4K3;
Date: Fri, 7 Jan 2011 14:27:57 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI / PM: Use pm_wakeup_event() directly for
 reporting wakeup events
Message-ID: <20110107142757.57fb2f1e@jbarnes-desktop>
In-Reply-To: <201012291321.23899.rjw@sisk.pl>
References: <201012291320.22777.rjw@sisk.pl>
	<201012291321.23899.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 13:21:23 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> After recent changes related to wakeup events pm_wakeup_event()
> automatically checks if the given device is configured to signal
> wakeup, so pci_wakeup_event() may be a static inline function
> calling pm_wakeup_event() directly.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Applied these two, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
