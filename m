Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2DFPNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:13:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753870Ab2DFPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:13:02 -0400
Date: Fri, 6 Apr 2012 11:13:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: host: tegra: re-arranging ehci functions
In-Reply-To: <1333685418-20801-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1204061112440.1392-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Venu Byravarasu wrote:

> Re-arranged EHCI generic and tegra specific functions
> into two separate groups for more readability.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

