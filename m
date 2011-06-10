Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab1FJPNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:13:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37645 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757538Ab1FJPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:12:58 -0400
Date: Fri, 10 Jun 2011 11:12:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] usb:dummy_hcd: Force FS device connection according
 to module parameter
In-Reply-To: <1307703207-14087-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106101112410.1921-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Tatyana Brokhman wrote:

> This patch adds a new module parameter to dummy_hcd: is_high_speed
> When set to false the connected device will be forced to operate in FS
> mode. The default of this parameter is true.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

