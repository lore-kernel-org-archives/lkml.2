Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab0CXUjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:39:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48064 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932365Ab0CXUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:39:09 -0400
Date: Wed, 24 Mar 2010 20:43:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: turbolad995@yahoo.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: Major Linux sound bugs
Message-ID: <20100324204305.4613bde9@lxorguk.ukuu.org.uk>
In-Reply-To: <4BAA6405.968.842BC@turbolad995.yahoo.co.uk>
References: <4BAA6405.968.842BC@turbolad995.yahoo.co.uk>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 19:12:05 -0000
turbolad995@yahoo.co.uk wrote:

> Hi. I don't know who to contact about this, but nobody seems to know 
> how to fix this problem or where/why it's occurring.  Here's the 
> lowdown: in Linux distributions such as Ubuntu, some programs will 
> only work with sound when you close ALL other programs first. I've 
> mentioned this on Launchpad, but nobody seems to know why or how to 
> fix it. 

Sound arbitration is pretty much entirely done in user space. You need to
talk to your distribution about it and how the software it uses is
configured. Probably some of what is shipped is not configured to share
nicely or you've added something which doesn't play nice.

Alan
