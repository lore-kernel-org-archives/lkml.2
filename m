Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab1KUUwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:52:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33009 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1KUUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:52:34 -0500
Date: Mon, 21 Nov 2011 20:52:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-wmi: Change debug statements from pr_info to
 pr_debug
Message-ID: <20111121205230.GA14467@srcf.ucam.org>
References: <1321908536-5163-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321908536-5163-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're intended to be there, in the same way that the keyboard code 
generates unknown scancode errors. We want to know when users have keys 
that don't work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
