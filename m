Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0KHLHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:07:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:61629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab0KHLHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="675312338"
Date: Mon, 8 Nov 2010 10:46:41 +0000
From: Alan Cox <alan@linux.intel.com>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6 v3] serial: Add support for UART on VIA VT8500 and
 compatibles
Message-ID: <20101108104641.07587f50@linux.intel.com>
In-Reply-To: <20101108005853.GA21872@alchark-u3s.lan>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<1289147348-31969-2-git-send-email-alchark@gmail.com>
	<20101107230801.5214f353@linux.intel.com>
	<20101108005853.GA21872@alchark-u3s.lan>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static struct console vt8500_console = {
> +	.name = "ttyS",

You missed a ttyS

Otherwise looks great.

Alan
