Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab2LHGuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 01:50:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59387 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab2LHGuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 01:50:07 -0500
Subject: Re: A typo about kernelcore= ?
From: anish kumar <anish198519851985@gmail.com>
To: Han Pingtian <hanpt@linux.vnet.ibm.com>, mgorman@suse.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20121207070241.GA2464@localhost.localdomain>
References: <20121207070241.GA2464@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Dec 2012 22:48:56 -0800
Message-ID: <1354949336.22178.4.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 15:02 +0800, Han Pingtian wrote:
> Hi there,
> 
> I'm wondering this is a typo in Documentation/kernel-parameters.txt
> about "kernelcore=":
>     
>     .... In the event, a node is too small to have both
>     kernelcore and Movable pages, kernelcore pages will
>     take priority and other nodes will have a larger number
>     of kernelcore pages.
> 
> I think it should be 
> 
>     .... In the event, a node is too small to have both
>     kernelcore and Movable pages, kernelcore pages will
>     take priority and other nodes will have a larger number
>     of *Movable* pages.
> 
> Is it right? Thanks in advance!
adding the maintainer.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


