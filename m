Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab2C2U4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:56:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46224 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933819Ab2C2U4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:56:39 -0400
Date: Thu, 29 Mar 2012 21:56:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org, Romain Francoise <romain@orebokech.com>,
        Chris Holland <bandidoirlandes@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hatem Masmoudi <hatem.masmoudi@gmail.com>, janek <jan0x6c@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH resend] ASPM: Fix pcie devices with non-pcie children
Message-ID: <20120329205635.GA2072@srcf.ucam.org>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
 <20120329163206.GA3480@burratino>
 <20120329134614.438e8aaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120329134614.438e8aaf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:46:14PM -0700, Andrew Morton wrote:

> Just about the only person who wasn't copied on this email is, umm, the
> PCI maintainer!

Jesse just handed that off to Bjorn…

-- 
Matthew Garrett | mjg59@srcf.ucam.org
