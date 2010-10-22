Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0JVTLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:11:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58330 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0JVTLn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 22 Oct 2010 15:11:43 -0400
Date: Fri, 22 Oct 2010 15:11:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] x86: define arch_vm_get_page_prot to
 set _PAGE_IOMAP on VM_IO vmas
Message-ID: <20101022191101.GA10177@dumpdata.com>
References: <4CC0C14E.5080205@goop.org>
 <4CC0C318.90401@zytor.com>
 <4CC0CA07.3000306@goop.org>
 <4CC0DEB8.1060309@zytor.com>
 <20101022150826.GA23325@dumpdata.com>
 <4CC1BF58.9020001@zytor.com>
 <20101022180231.GA26365@dumpdata.com>
 <4CC1E0B9.5060403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC1E0B9.5060403@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I hope my explanation cleared the confusion.
> > 
> >> me and I'm not sure it is the right solution.
> 
> OK, now I'm *positive* this isn't the right solution...

Uhhh.. could you elaborate on a right solution?
