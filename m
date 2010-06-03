Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab0FCBSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:18:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab0FCBSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:18:17 -0400
Date: Wed, 2 Jun 2010 18:18:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Jacob Pan <jacob.jun.pan@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, i8259: Only register sysdev for real PIC
Message-Id: <20100602181814.63b173be.akpm@linux-foundation.org>
In-Reply-To: <20100602113150.GB21413@os.inf.tu-dresden.de>
References: <20100602113150.GB21413@os.inf.tu-dresden.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 13:31:50 +0200 Adam Lackorzynski <adam@os.inf.tu-dresden.de> wrote:

> Do not register the sysdev function when the null_legacy_pic is used so
> that the i8259 resume, suspend and shutdown functions are not called.

What are the effects of this change?  Does it fix an oops or a hang, or
nothing at all, or...?

