Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab1DGXVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:21:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:55851 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1DGXVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:21:38 -0400
Subject: Re: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
In-Reply-To: <20110407.153121.115952367.davem@davemloft.net>
References: <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
	 <20110407.152707.39195948.davem@davemloft.net>
	 <20110407.152937.59699180.davem@davemloft.net>
	 <20110407.153121.115952367.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 09:21:19 +1000
Message-ID: <1302218479.2458.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 15:31 -0700, David Miller wrote:
> I don't think it's a good idea to mix the things you're trying to do
> with all of the existing stuff in of_pci.c, why not create a new file
> for the stuff you're trying to consolidate? 

I can move that new function to pci/of.c then. 

Cheers,
Ben.


