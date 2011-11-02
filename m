Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1KBNVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:21:34 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52852 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755501Ab1KBNVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:21:30 -0400
Date: Wed, 2 Nov 2011 13:21:24 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix off-by-two in arcs_cmdline buffer size check
Message-ID: <20111102132123.GA18568@linux-mips.org>
References: <4EAC0394.5000807@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAC0394.5000807@intra2net.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 03:45:56PM +0200, Thomas Jarosch wrote:

> Cause is a misplaced bracket.
> 
> The code
> 
>     strlen(buf+1)
> 
> will be two bytes less than
> 
>     strlen(buf)+1
> 
> The +1 is in this code to reserve space for an additional space character.

Thanks, applied.

The same buggy code just formatted slightly differently also exists in
Emma.  I added the Emma fix to the patch and applied it.

Thanks!

  Ralf
