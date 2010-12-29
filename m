Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0L2VUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:20:47 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:39482 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752795Ab0L2VUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:20:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lsz+8WI0bcP+fRBdE0KNlcdhWWtbRKX456SaVsYBvMmcw7u11bgxotspQSjHOmec6uSa+fdIGX6/R0efliT0PhAT5tvqcNCLL0HB5rrX30Uq2RaPwK6VevKWJwl8XSCg;
Date: Wed, 29 Dec 2010 13:20:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: andrei radulescu-banu <iubica2@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is PCI express Gen 2 supported by Linux?
Message-ID: <20101229132040.21e11005@jbarnes-desktop>
In-Reply-To: <446161.64736.qm@web56607.mail.re3.yahoo.com>
References: <446161.64736.qm@web56607.mail.re3.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 12:48:37 -0800 (PST)
andrei radulescu-banu <iubica2@yahoo.com> wrote:

> I've scanned the PCI information under Documentation/PCI in the source tree, but could not find this information. I am not sure if PCIe gen 2 requires special software support in the PCI layer, or if the hardware hides any PCIe version differences from the Linux PCI driver.

PCIe 2.x works fine with Linux.  We don't support all of the PCIe 2.x
extensions though, so depending on your device not all features may be
enabled.

-- 
Jesse Barnes, Intel Open Source Technology Center
