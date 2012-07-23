Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2GWN2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:28:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57437 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2GWN2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:28:48 -0400
Date: Mon, 23 Jul 2012 14:28:41 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, don@syst.com.br,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] classmate-laptop: Add support for Classmate V4
 accelerometer.
Message-ID: <20120723132841.GD21495@srcf.ucam.org>
References: <cover.1340976795.git.magomez@igalia.com>
 <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com>
 <20120717224749.GA20813@nautilus.holoscopio.com>
 <5006BFEC.1010407@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5006BFEC.1010407@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 03:53:48PM +0200, Miguel Gómez wrote:

> >1) reverting the patch in acpica that puts all names in uppercase
> >2) using a case-insensitive match in acpi bus driver
> >3) using uppercase name in classmate-laptop driver
> 
> I think the easiest and less risky way to fix this is by adding a
> new hardware id (as proposed in the thread's patch), as it doesn't
> add any side effects (that the other solutions might add), and it
> doesn't break the behaviour of the old code.

I've lost track of the implementation state here - if all names are 
upper-cased in acpica, why is this not already matching?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
