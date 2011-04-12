Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1DLQOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:14:00 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:55533 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758079Ab1DLQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:13:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SR2kZwtA2ek+D34J8pVpCB+sKETd5fwCpMC+je2aWMY4+rC3gTI3P5NTXsDY6Xm340BMyuD4Spp0iyBTe9H9v1GbzURUnb1CCcNVk2jC7LZU4Dhap8rNissb0+mgCUM/;
Date: Tue, 12 Apr 2011 09:13:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: wanlong.gao@gmail.com
Cc: prarit@redhat.com, kaneshige.kenji@jp.fujitsu.com,
        seto.hidetoshi@jp.fujitsu.com, arnd@arndb.de,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        harryxiyou@gmail.com
Subject: Re: [PATCH]X86:PCI: Fix an uninitialized variable warning
Message-ID: <20110412091346.1afa945f@jbarnes-desktop>
In-Reply-To: <1301908379-19283-1-git-send-email-wanlong.gao@gmail.com>
References: <1301908379-19283-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Apr 2011 17:12:59 +0800
wanlong.gao@gmail.com wrote:

> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> If it was preempted , and the variable aer_mask_override is
> changed after the spin_unlock_irqrestore ,  it will write an
> uninitialized variable by the pci_write_config_dword() function .

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
