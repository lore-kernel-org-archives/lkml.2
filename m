Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0LTSWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:22:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46486 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab0LTSWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:22:52 -0500
Date: Mon, 20 Dec 2010 18:22:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.36.2 regression: suspend on Lenovo X200s broken due to TPM
Message-ID: <20101220182242.GA29696@srcf.ucam.org>
References: <AANLkTikaxPEszPPU=J1bP2TitrrDuhZ=FZKbD2hwD+VH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikaxPEszPPU=J1bP2TitrrDuhZ=FZKbD2hwD+VH@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 01:10:03PM -0500, Andrew Lutomirski wrote:
> The change "PNPACPI: cope with invalid device IDs", added in 2.6.36.2,
> makes the kernel detect my TPM (it used to not work at all), but the
> TPM driver doesn't work because it can't autodetect the iTPM
> workaround.  This breaks suspend without actually fixing my TPM.

I hadn't realised that patch went back to stable. Greg, you'll want to 
pull 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
