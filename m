Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab0JGNfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:35:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60227 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760534Ab0JGNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:35:37 -0400
Date: Thu, 7 Oct 2010 14:35:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <superm1@ubuntu.com>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
Message-ID: <20101007133529.GA21782@srcf.ucam.org>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com> <20101007111510.GA19624@srcf.ucam.org> <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 08:30:57AM -0500, Mario Limonciello wrote:

>    In this specific scenario that Ken Yu submitted this patch for, the
>    firmware will return the same return codes for the SMI's as a functional
>    machine will.  Machines affected by this will fail to recover after rfkill
>    is toggled twice.  The symptom will be that the soft block always appears
>    set to the same setting with continued keypresses.
>    During the prototype phase this option is quite useful to help debug the
>    problem it addresses.

Is the kernel able to unblock it under those circumstances?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
