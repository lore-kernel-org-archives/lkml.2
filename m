Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1F2Mz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:55:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:22823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab1F2MzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:55:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="21880305"
Date: Wed, 29 Jun 2011 13:55:02 +0100
From: Alan Cox <alan@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH] tty: serial: samsung.c remove legacy PM code.
Message-ID: <20110629135502.2261f9e8@bob.linux.org.uk>
In-Reply-To: <1309328904-19267-1-git-send-email-myungjoo.ham@samsung.com>
References: <1309328904-19267-1-git-send-email-myungjoo.ham@samsung.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 15:28:24 +0900
MyungJoo Ham <myungjoo.ham@samsung.com> wrote:

> This patch "modernize" tty/serial/samsung.c to use non-legacy code for
> suspend/resume.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>

Looks fine to me - no tty/serial bits involved though
