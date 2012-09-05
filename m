Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2IEFQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:16:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51496 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2IEFQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:16:56 -0400
Date: Wed, 5 Sep 2012 06:16:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120905051652.GA5133@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
 <20120904212717.GA30899@srcf.ucam.org>
 <87fw6xtp23.fsf@xmission.com>
 <20120904232503.GA1077@srcf.ucam.org>
 <871uihozqc.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uihozqc.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 09:33:31PM -0700, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > The full implementation should trust keys that are trusted by the 
> > platform, so it'd boot any kexec image you cared to sign. Or simply 
> > patch this code out and rebuild and self-sign, or disable the code that 
> > turns off the capability when in secure boot mode. I've no objection to 
> > putting that behind an #ifdef.
> 
> I will be happy to see a version of kexec that accepts signed images,
> allowing the functionality to work in your brave new world where
> everything must be signed.
> 
> Until then I don't see a point in merging anything else.

Fine. We'll just carry this one out of tree for now.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
