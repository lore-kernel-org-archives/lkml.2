Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0EIOgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:36:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:48581 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0EIOgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:36:07 -0400
Date: Sun, 9 May 2010 07:38:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Link time manipulation of kernel symbols like read/write
Message-ID: <20100509073842.5f593dd1@infradead.org>
In-Reply-To: <j2if22d86811005082351x975e868foe1b40bf7a89e1448@mail.gmail.com>
References: <y2gf22d86811005071051q28a4fa84g2a3ea1a7ff487934@mail.gmail.com>
	<j2if22d86811005082351x975e868foe1b40bf7a89e1448@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 May 2010 12:21:35 +0530
"Leonidas ." <leonidas137@gmail.com> wrote:

> Couple more questions:
> 
> 1. How does the dynamic linking/loading happen in kernel? What is the
> equivalent of ld-linux.so in kernel space?

lkml is not rootkit-help-for-free ;-)

