Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab1DHTum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:50:42 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:56622 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757780Ab1DHTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:50:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UegHnFXLdlFtA2aGnuU7BjsNrVekvYXDn0hkmoLh3yLQgdiAVDcx8Ii9kdknrUntkP9YbkAc//sg8Y0UkXTGJe+Hv+jrA+AWPmFcNvwaotHdl1RqQIEwJX66d7SJwoDu;
Date: Fri, 8 Apr 2011 12:50:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] PCI / PM: Add kerneldoc description of
 pci_pm_reset()
Message-ID: <20110408125031.09d667f2@jbarnes-desktop>
In-Reply-To: <201103052148.44413.rjw@sisk.pl>
References: <201103051324.27461.rjw@sisk.pl>
	<201103052148.44413.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011 21:48:44 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The pci_pm_reset() function is not a very nice interface due to its
> limitations and conditional behavior (e.g. it doesn't affect devices
> in low-power states), but it cannot be simply dropped, because
> existing device drivers may depend on it.  However, its behavior and
> limitations should be well documented, so add an appropriate
> kerneldoc comment to it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
