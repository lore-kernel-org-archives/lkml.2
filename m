Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab2C2VAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:00:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933866Ab2C2U76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:59:58 -0400
Date: Thu, 29 Mar 2012 13:59:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org, Romain Francoise <romain@orebokech.com>,
        Chris Holland <bandidoirlandes@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hatem Masmoudi <hatem.masmoudi@gmail.com>, janek <jan0x6c@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH resend] ASPM: Fix pcie devices with non-pcie children
Message-Id: <20120329135956.7034cd9d.akpm@linux-foundation.org>
In-Reply-To: <20120329205635.GA2072@srcf.ucam.org>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
	<20120329163206.GA3480@burratino>
	<20120329134614.438e8aaf.akpm@linux-foundation.org>
	<20120329205635.GA2072@srcf.ucam.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 21:56:35 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Mar 29, 2012 at 01:46:14PM -0700, Andrew Morton wrote:
> 
> > Just about the only person who wasn't copied on this email is, umm, the
> > PCI maintainer!
> 
> Jesse just handed that off to Bjorn…

Oh.  So he did.   My search of MAINTAINERS turned up the probably wrong

T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci.git
