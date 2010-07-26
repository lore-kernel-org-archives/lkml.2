Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0GZOEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:04:45 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:53326 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab0GZOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:04:43 -0400
Date: Mon, 26 Jul 2010 15:04:17 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Chris Dearman <chris@mips.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] arch/mips/kernel/smtc.c: formatting of pointers in
 printk()
Message-ID: <20100726140417.GA12084@linux-mips.org>
References: <1279130502-10777-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279130502-10777-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:01:42PM +0400, Kulikov Vasiliy wrote:

> Use %p instead of %08x in printk().

Queued for 2.6.36, thanks!

Yes, %p is prefered here.  But your log message doesn't mention that your
patch also does a functional change, it drops the 0x prefix of the printed
value ...

  Ralf
