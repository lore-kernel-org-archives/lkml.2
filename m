Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab1CITCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:02:38 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:55509 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1CITCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:02:36 -0500
Date: Wed, 9 Mar 2011 14:02:30 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
Message-ID: <20110309190230.GB2808@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
References: <E1PuKHL-0000lw-RM@tytso-glaptop>
 <4D6CFA80.3020505@linux.vnet.ibm.com>
 <AANLkTi=BtfXYV+1_JZh0SRZhJz=Ys3wCF-t5rBR2iz8O@mail.gmail.com>
 <4D6D61B1.7000302@linux.vnet.ibm.com>
 <20110301213756.GA2959@thunk.org>
 <4D70FAC2.5010109@linux.vnet.ibm.com>
 <20110305164837.GB11120@thunk.org>
 <4D759AB8.4020300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D759AB8.4020300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:55:52PM -0300, Rajiv Andrade wrote:
> Ah.. completely different story then, I thought you were seeing the
> timeouts for
> _any_ command, sorry. Just to confirm, can you issue a tpm_version?
> I believe you
> might have them already, but this requires the tpm-tools and
> trousers packages
> installed.

Here you go:

% tpm_version
  TPM 1.2 Version Info:
  Chip Version:        1.2.8.16
  Spec Level:          2
  Errata Revision:     2
  TPM Vendor ID:       STM 
  TPM Version:         01010000
  Manufacturer Info:   53544d20

						- Ted


