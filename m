Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1F1Rn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:43:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33516 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760087Ab1F1Rlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:41:46 -0400
Date: Tue, 28 Jun 2011 18:41:38 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Make Dell Latitude E6320 use reboot=pci
Message-ID: <20110628174137.GA18115@srcf.ucam.org>
References: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 03:57:31PM +0200, Maxime Ripard wrote:
> The Dell Latitude E6320 doesn't reboot unless reboot=pci is set.

On which kernel versions?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
