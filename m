Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1GERwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:52:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56552 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1GERwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:52:32 -0400
Date: Tue, 5 Jul 2011 18:52:24 +0100
From: Matthew Garrett <mjg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Marc Koschewski <marc@osknowledge.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_ACPI_PROCFS_POWER to be removed in 2.6.39
Message-ID: <20110705175224.GB30531@srcf.ucam.org>
References: <20110630213728.GA30291@marc.osknowledge.org>
 <BANLkTimk_yCCy+4hL6949nxPs5Qo4y1Qow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimk_yCCy+4hL6949nxPs5Qo4y1Qow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 08:55:23AM +0800, Américo Wang wrote:
> On Fri, Jul 1, 2011 at 5:37 AM, Marc Koschewski <marc@osknowledge.org> wrote:
> > Hey guys,
> >
> > CONFIG_ACPI_PROCFS_POWER is still there. Missed it or did you want it
> > to reside?
> 
> There was a patch to remove it,
> 
> https://patchwork.kernel.org/patch/654021/
> 
> Don't know why it is not merged.

There's still plenty of userspace using it. There probably ought to at 
least be a period where using it generates a deprecation warning.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
