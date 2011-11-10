Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab1KJAyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:54:10 -0500
Received: from shutemov.name ([188.40.19.243]:36045 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab1KJAyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:54:08 -0500
Date: Thu, 10 Nov 2011 02:54:07 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/262] 3.0.9-stable review
Message-ID: <20111110005406.GA22026@shutemov.name>
References: <20111109212847.GA20838@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109212847.GA20838@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 01:28:47PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 3.0.9 release.

Could you include these two:

a94cc4e sfi: table irq 0xFF means 'no interrupt'
153b19a x86, mrst: use a temporary variable for SFI irq

-- 
 Kirill A. Shutemov
