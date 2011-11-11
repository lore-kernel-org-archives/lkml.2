Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1KKT2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:28:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54718 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1KKT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:27:59 -0500
Date: Fri, 11 Nov 2011 19:27:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Roland Dreier <roland@purestorage.com>
Cc: linux-kernel@vger.kernel.org, faisal.latif@intel.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 6/6] infiniband/nes: Disable ASPM
Message-ID: <20111111192753.GA19111@srcf.ucam.org>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com>
 <1321027511-31229-7-git-send-email-mjg@redhat.com>
 <CAL1RGDWw7zceDcZZaS7C3YeADR5-py5Roz_CdSeZ4N3yH4uJnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDWw7zceDcZZaS7C3YeADR5-py5Roz_CdSeZ4N3yH4uJnw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 09:31:44AM -0800, Roland Dreier wrote:
> On Fri, Nov 11, 2011 at 8:05 AM, Matthew Garrett <mjg@redhat.com> wrote:
> > The Windows driver .inf disables ASPM on hpsa devices. Do the same.
> 
> This isn't a patch to the hpsa driver... cut and paste in the description,
> or misfire on the patch?

Sorry, yes, cut and paste in the description. It should say nes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
