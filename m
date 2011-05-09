Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1EILFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:05:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:57156 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1EILFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:05:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,340,1301900400"; 
   d="scan'208";a="919893578"
Date: Mon, 9 May 2011 11:50:48 +0100
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] pch_uart: Support new device ML7223 IOH
Message-ID: <20110509115048.69d88311@bob.linux.org.uk>
In-Reply-To: <1304929520-5798-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304929520-5798-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 May 2011 17:25:20 +0900
Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
> The ML7223 IOH is for MP(Media Phone) use.
> The ML7223 is companion chip for Intel Atom E6xx series.
> The ML7223 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Acked-by: Alan Cox <alan@linux.intel.com>
