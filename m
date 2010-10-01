Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0JAPHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:07:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:61945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab0JAPHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:07:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,267,1283756400"; 
   d="scan'208";a="663086710"
Date: Fri, 1 Oct 2010 15:18:41 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] altera_uart: Make it possible to use Altera UART
 and 8250 ports together
Message-ID: <20101001151841.3fad627c@linux.intel.com>
In-Reply-To: <20101001135254.GA27739@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
	<20101001132207.GE25897@oksana.dev.rtsoft.ru>
	<20101001134138.5ea2fb55@linux.intel.com>
	<20101001135254.GA27739@oksana.dev.rtsoft.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess the sane maximum number of ports would be 8, but it is still
> possible to do hundreds of them.

In that case you may just want to allocate a dynamic major instead - or
do you actually need a fixed major/minor for your boot up ?

