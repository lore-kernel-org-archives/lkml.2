Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0EKDj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:39:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55959 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab0EKDjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:39:22 -0400
Date: Mon, 10 May 2010 21:39:19 -0600
From: Alex Chiang <achiang@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [87/98] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100511033919.GB7513@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
	Len Brown <len.brown@intel.com>
References: <20100510223714.GA18416@kroah.com>
 <20100510223542.221366082@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510223542.221366082@kvm.kroah.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> 
> From: Alex Chiang <achiang@canonical.com>
> 
> commit 07bedca29b0973f36a6b6db36936deed367164ed upstream.
> 
> Multiple Lenovo ThinkPad models with Intel Core i5/i7 CPUs can
> successfully suspend/resume once, and then hang on the second s/r
> cycle.

My comment on the same version of this patch for the .33-stable
tree applies here too.

Thanks,
/ac

