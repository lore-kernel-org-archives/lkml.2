Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935594Ab0GPDi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:38:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:54719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935392Ab0GPDi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:38:27 -0400
Date: Thu, 15 Jul 2010 20:42:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Make CONFIG_DEBUG_RODATA boot-time configurable
Message-ID: <20100715204233.370b6aa2@infradead.org>
In-Reply-To: <20100715210944.GA24961@redhat.com>
References: <20100715210944.GA24961@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 17:09:44 -0400
Dave Jones <davej@redhat.com> wrote:

> We had a request to disable DEBUG_RODATA in our kernel for debugging
> purposes. Turning it off completely seems a bit unfortunate for the
> minority case of people wanting to do debugging, so I came up with
> this patch to make it a boot-time 'disable_rodata' argument.


I'd be very curious what kind of debugging this is...
is this the rootkit type of debugging?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
