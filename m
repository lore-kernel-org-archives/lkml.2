Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab2CWMuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:50:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33593 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab2CWMuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:50:02 -0400
Date: Fri, 23 Mar 2012 12:49:57 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Chris Holland <bandidoirlandes@gmail.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop
 3.3.0-030300-generic
Message-ID: <20120323124957.GB18615@srcf.ucam.org>
References: <CAMfrEMaV03CEZ-h7k9K78c8+T+AC47=QypnyhQG7LFgrQQ32tA@mail.gmail.com>
 <4F6AAC57.3090507@gmail.com>
 <CAMfrEMbUsdnQ3Roe89YaV5F2xhTwbgRhWcM9E1jizqUEbCi=QQ@mail.gmail.com>
 <CADLC3L29fiago4Nkxbb3Ey8iS3GGp_G_NP77esdAqQVYHFLBLw@mail.gmail.com>
 <CAMfrEMYUWG39Z-y8sU+7eDdePQWg9U5kow_ipZANwD-s=BOh_A@mail.gmail.com>
 <CAMfrEMZ27UWKTASUFaEG1KLysRgAukVruOx2Q-s-FXzOQJe_zA@mail.gmail.com>
 <CAMfrEMa65+X1zA5fQ7R+Zt8tGjf9XtcHnPodiJgy+9bwO-nFkg@mail.gmail.com>
 <CADLC3L2XSJoPtt3g+GAc=JvMz3OjFewnt-BPBPyrVG+ZcxvW4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADLC3L2XSJoPtt3g+GAc=JvMz3OjFewnt-BPBPyrVG+ZcxvW4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 11:22:53PM -0600, Robert Hancock wrote:

> pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
> enable it with 'pcie_aspm=force'
>
> Before this patch we would have been forcing ASPM off on this device,
> whereas now it appears we'll leave it as it was. Maybe this device
> busts somehow if ASPM is allowed to be left on for it?

That shouldn't (in theory) be the case. I'll look into it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
