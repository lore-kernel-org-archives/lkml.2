Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2DYK5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:57:03 -0400
Received: from shutemov.name ([176.9.204.213]:42975 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757695Ab2DYK5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:57:00 -0400
Date: Wed, 25 Apr 2012 13:57:15 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH] x86: mrst: quiet sparse noise about plain integer as
 NULL pointer
Message-ID: <20120425105715.GA9297@shutemov.name>
References: <201204241500.53685.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201204241500.53685.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 03:00:53PM -0700, H Hartley Sweeten wrote:
> The second parameter to intel_scu_notifier_post is a void * not an integer.
> 
> This quiets the sparse noise:
> 
> arch/x86/platform/mrst/mrst.c:808:48: warning: Using plain integer as NULL pointer
> arch/x86/platform/mrst/mrst.c:817:43: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
