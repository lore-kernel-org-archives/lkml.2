Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1LASsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:48:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36394 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756090Ab1LASsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:48:39 -0500
Message-ID: <1322765318.30801.9.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] nfc: Use standard logging styles
From: Joe Perches <joe@perches.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Dec 2011 10:48:38 -0800
In-Reply-To: <20111201155951.GF22609@sortiz-mobl>
References: <cover.1322595343.git.joe@perches.com>
	 <6c89a76ddb76926febe36fe5be514cb186e39a76.1322595343.git.joe@perches.com>
	 <20111201155951.GF22609@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 16:59 +0100, Samuel Ortiz wrote:
> Hi Joe,

Hello Samuel.

> On Tue, Nov 29, 2011 at 11:37:32AM -0800, Joe Perches wrote:
> > Using the normal logging styles is preferred over
> > subsystem specific styles when the subsystem does
> > not take a specific struct.
> > Convert nfc_<level> specific messages to pr_<level>
> > Add newlines to uses.
> I would be fine with moving to pr_debug, but I'd like the pr_fmt() routine to
> include the function name as well.

If you really want it I can add it back but
if you are not aware, dynamic debug can add
this by using:

echo "module nfc +fp" > <debugfs>/dynamic_debug/control
echo "module nci +fp" > <debugfs>/dynamic_debug/control

If you're getting dmesg logs from customers
that's a bit harder to track though.


