Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0DOKjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:39:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39314 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753219Ab0DOKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:39:44 -0400
Date: Thu, 15 Apr 2010 11:44:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joseph Krahn <joseph.krahn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trying to fix ITE-887x parallel/serial driver bugs (including 
 unhandled IRQs)
Message-ID: <20100415114409.466cbf60@lxorguk.ukuu.org.uk>
In-Reply-To: <z2qff6de6f21004141046ke8eb9f62q4cdd87dc136f76a1@mail.gmail.com>
References: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
	<20100412174352.4e13113f@lxorguk.ukuu.org.uk>
	<n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
	<20100414131140.5c6187ab@lxorguk.ukuu.org.uk>
	<z2qff6de6f21004141046ke8eb9f62q4cdd87dc136f76a1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> but all have the same PCI id. My code just lets parport_serial handle
> the serial-only and parallel-only cases. Is that approach better than
> having two modules that both match the same PCI id?

Most distributions load each driver that matches an id anyway so I think
so - puts the complexity in one place.

Alan
