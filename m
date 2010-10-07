Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0JGVZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:25:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35066 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab0JGVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:25:00 -0400
Date: Thu, 7 Oct 2010 22:24:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <superm1@ubuntu.com>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
Message-ID: <20101007212451.GA1458@srcf.ucam.org>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com> <20101007111510.GA19624@srcf.ucam.org> <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com> <20101007133529.GA21782@srcf.ucam.org> <AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com> <20101007205049.GB32726@srcf.ucam.org> <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 03:53:37PM -0500, Mario Limonciello wrote:

> Yes the issue is the firmware's response to the keystroke.  The
> intention here is to individual submit machines in future patches as
> they're discovered.  The parameter's primary purpose is to assist in
> building the list.  If someone reports a bug with these symptoms, they
> can add the parameter to their kernel command line, and report if it
> helps them.  If it helps, their machine can be added to the DMI table.

Sorry, I'm not adding this as a module option. How can you not know 
which machines are affected?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
