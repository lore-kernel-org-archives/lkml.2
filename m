Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1DTPOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:14:09 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33800 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754333Ab1DTPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:14:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mDnYa5rfb7bUtHt/bvmAOM2ImIfCO3coVKg3FI7PkwVwod+pdUwHTVSyRdtgSj/yp8UVUleh82ZpwHLchhCcOSKXz/Wd1oqvf053K0RVp18OCbIawU9ZxsPWBuDxsYo2;
Date: Wed, 20 Apr 2011 08:14:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg Thelen <gthelen@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: check pci_vpd_pci22_wait() return
Message-ID: <20110420081401.48b9b5e1@jbarnes-desktop>
In-Reply-To: <1303053741-384-1-git-send-email-gthelen@google.com>
References: <1303053741-384-1-git-send-email-gthelen@google.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011 08:22:21 -0700
Greg Thelen <gthelen@google.com> wrote:

> pci_vpd_pci22_write() calls pci_vpd_pci22_wait() after writing
> PCI_VPD_DATA and PCI_VPD_ADDR to wait for the VPD operation to complete.
> The result pci_vpd_pci22_wait() was not checked for error.
> 
> This change checks for error.

Applied the two return value fixes to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
