Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1JIIRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 04:17:24 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:38548 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1JIIRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 04:17:22 -0400
Date: Sun, 9 Oct 2011 10:17:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Williams <steveicarus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MODULE_LICENSE("GPL") not working for me
Message-ID: <20111009081719.GA20927@merkur.ravnborg.org>
References: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com> <CAO3ZPq2RUjW7VQQSoN-S7QDuTYdCMuDfoykHSeXwr19MTnCb_A@mail.gmail.com> <20111007181826.GA20210@merkur.ravnborg.org> <CAO3ZPq0JU7854=AYR9a8SRcacUn1=7BhfCP=s93SJFTtmpuGSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO3ZPq0JU7854=AYR9a8SRcacUn1=7BhfCP=s93SJFTtmpuGSQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 05:36:22PM -0700, Stephen Williams wrote:
> I've attached the Makefile as I have it so far, and I've also attached the
> output from make ... V=2. The Makefile is a canonical multi-object-file
> module makefile, with some extra trappings for version stamping
> and my source code management.
> 
> When I look at the object files, NONE of the generated *.o files contains
> a .modinfo section, even though there are MODULE_LICENSE("GPL");
> lines in the linux.c source file.
> 
> Incidentally, the source files in the ../libvidforio directory are generic,
> so do not include any kernel header files.

Looks like you do not have CONFIG_MODULE defined in you kernel config.
When using external modules there is today no consistency check that
CONFIG_MODULE is set when building a module.

	Sam
