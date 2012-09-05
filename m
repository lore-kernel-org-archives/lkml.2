Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2IEHD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:03:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53812 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2IEHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:03:26 -0400
Date: Wed, 5 Sep 2012 08:03:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120905070322.GA8014@srcf.ucam.org>
References: <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
 <20120904212717.GA30899@srcf.ucam.org>
 <87fw6xtp23.fsf@xmission.com>
 <20120904232503.GA1077@srcf.ucam.org>
 <871uihozqc.fsf@xmission.com>
 <20120905051652.GA5133@srcf.ucam.org>
 <871uihnecw.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uihnecw.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:00:31AM -0700, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > Fine. We'll just carry this one out of tree for now.
> 
> It is your tree.
> 
> I am disappointed to learn that you aren't enthusiastic about
> implementing verification of signatures for all code that goes into
> ring 0.

I am enthusiastic, but October 26th is a date outside my control and 
kexec isn't at the top of the priority list. We ship with the code we 
have, not the code we want.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
