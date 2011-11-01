Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1KAMo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:44:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:12180 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1KAMoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,438,1315206000"; 
   d="scan'208";a="32125141"
Date: Tue, 1 Nov 2011 12:55:03 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] pch_uart: Fix hw-flow control issue
Message-ID: <20111101125503.233847d1@bob.linux.org.uk>
In-Reply-To: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011 15:45:18 +0900
Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com> wrote:

> Using hardware flow control,
> currently, register of the control-bit(AFE) is not set.
> This patch fixes the issue.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

Acked-by: Alan Cox <alan@linux.intel.com>
