Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1DLQPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:15:45 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:33177 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758099Ab1DLQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:15:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=E/mJQ0KNkuiaIdDK9tTca6uNEPCqFJIYzXOX9O+PgV4MQZ1FXmEQiQV+AgdSXIOC9LMftGzMUoCk9LuwRKPr+Z07zhDCfbsEP9wVSDLj0YkmA6oeco0whWumxjl5oL9P;
Date: Tue, 12 Apr 2011 09:15:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hemant Pedanekar <hemantp@ti.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] pci: Add quirk for setting valid class for TI816X
 Endpoint
Message-ID: <20110412091533.224387a8@jbarnes-desktop>
In-Reply-To: <1301986970-16482-1-git-send-email-hemantp@ti.com>
References: <1301986970-16482-1-git-send-email-hemantp@ti.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Apr 2011 12:32:50 +0530
Hemant Pedanekar <hemantp@ti.com> wrote:

> TI816X (common name for DM816x/C6A816x/AM389x family) devices configured to boot
> as PCIe Endpoint have class code = 0. This makes kernel PCI bus code to skip
> allocating BARs to these devices resulting into following type of error when
> trying to enable them:
> 
> "Device 0000:01:00.0 not available because of resource collisions"
> 
> The device cannot be operated because of the above issue.
> 
> This patch adds a ID specific (TI VENDOR ID and 816X DEVICE ID based) 'early'
> fixup quirk to replace class code with PCI_CLASS_MULTIMEDIA_VIDEO as class.
> 
> Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
> ---

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
