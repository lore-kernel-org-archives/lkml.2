Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab0KDNHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:07:13 -0400
Received: from smtp.nokia.com ([147.243.1.48]:32856 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751075Ab0KDNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:07:10 -0400
Subject: Re: mmotm 2010-10-31-21-24 uploaded (drivers/nfc/pn544)
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jari Vanhala <ext-jari.vanhala@nokia.com>
In-Reply-To: <20101101110024.bca61c57.randy.dunlap@oracle.com>
References: <201011010427.oA14R3Y6010534@imap1.linux-foundation.org>
	 <20101101110024.bca61c57.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Tue, 02 Nov 2010 09:57:10 +0200
Message-ID: <1288684630.1603.102.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-01 at 11:00 -0700, ext Randy Dunlap wrote:
> On Sun, 31 Oct 2010 21:25:59 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-10-31-21-24 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.36:
> > 
> > nfc-driver-for-nxp-semiconductors-pn544-nfc-chip.patch
> 
> 
> Use %zd to print ssize_t variables and %zu to print size_t:
> 
> drivers/nfc/pn544.c:332: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
> drivers/nfc/pn544.c:442: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'

Thanks, I'll do that... I'm using Sparse and checkpatch --strict but
neither gave me a warning about that.

Cheers,
Matti

> 
> 
> Also see Documentation/printk-formats.txt as needed.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


