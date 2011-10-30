Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1J3WIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 18:08:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:43720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1J3WIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 18:08:19 -0400
Date: Sun, 30 Oct 2011 15:12:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
Message-ID: <20111030151256.27b2b20e@infradead.org>
In-Reply-To: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Oct 2011 19:57:12 +0000 (GMT)
"Artem S. Tashkinov" <t.artem@lycos.com> wrote:

> Hello,
> 
> It's known that if you want to reach maximum performance on HT
> enabled Intel CPUs you should distribute the load evenly between
> physical cores, and when you have loaded all of them you should then
> load the remaining virtual cores.

this is a bold statement, and patently false if you have to threads of
one process that heavily share data between eachother...
(but true for more independent workloads)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
