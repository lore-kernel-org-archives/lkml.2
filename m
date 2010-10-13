Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0JMQkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:40:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56060 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0JMQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:40:18 -0400
Date: Wed, 13 Oct 2010 09:38:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 13 (net/3c59x)
Message-Id: <20101013093836.1ee6f2f9.randy.dunlap@oracle.com>
In-Reply-To: <20101013154522.7b087a20.sfr@canb.auug.org.au>
References: <20101013154522.7b087a20.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 15:45:22 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101012:


when CONFIG_PCI is not enabled:

drivers/net/3c59x.c:3211: error:request for member 'current_state' in something not a structure or union

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
