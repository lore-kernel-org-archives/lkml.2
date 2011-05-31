Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab1EaQnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:43:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57875 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1EaQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:43:09 -0400
Date: Tue, 31 May 2011 17:42:56 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add Dell E5420 reboot quirk
Message-ID: <20110531164256.GA8971@srcf.ucam.org>
References: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
 <69e8f8a9-4e8b-4c02-b566-304ff837d166@email.android.com>
 <BANLkTi=h5f6o3iVK24sQ20xYYQAMbLavMg@mail.gmail.com>
 <BANLkTik9BtnXxsOGKuhmoUFsKPbhBwXr3A@mail.gmail.com>
 <4DE3C652.5090309@zytor.com>
 <BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 12:52:15AM +0800, Daniel J Blueman wrote:
> On 31 May 2011 00:31, H. Peter Anvin <hpa@zytor.com> wrote:
> > Enabling the quirk is the right thing; however, if ACPI worked I'd have
> > preferred it since we just switched to ACPI as the default.
> 
> Indeed - the new and default ACPI reboot method works perfectly in
> 3.0-rc1, whereas with 2.6.39, it didn't, so no further need for this
> patch then.

It's not entirely equivalent to the way the ACPI reboot method worked in 
previous kernels, so it should work better.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
