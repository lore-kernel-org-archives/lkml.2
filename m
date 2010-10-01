Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0JANah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:30:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:61689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab0JANaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,266,1283756400"; 
   d="scan'208";a="330952466"
Date: Fri, 1 Oct 2010 13:41:38 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] altera_uart: Make it possible to use Altera UART
 and 8250 ports together
Message-ID: <20101001134138.5ea2fb55@linux.intel.com>
In-Reply-To: <20101001132207.GE25897@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
	<20101001132207.GE25897@oksana.dev.rtsoft.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 17:22:07 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> This fixes tty name and major number conflicts. The major number
> 204 is used across many platform-specific serial drivers, so we
> use that.

204 is allocated in small chunks to specific low volume devices so you
need a proper minor allocation

At this point that would be 204,213 for whatever tiny range you need.

Please send me a patch for devices.txt and update accordingly,
otherwise no objections.

Alan
