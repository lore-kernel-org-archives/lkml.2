Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1ALQ1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:27:01 -0500
Received: from thunk.org ([69.25.196.29]:48533 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1ALQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:26:58 -0500
Date: Wed, 12 Jan 2011 11:26:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Oops while going into hibernate
Message-ID: <20110112162655.GA13496@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sebastian Ott <sebott@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 02:48:58PM +0100, Sebastian Ott wrote:
> Hi,
> 
> while goning into hibernation right after resuming with
> 2.6.37-05668-g4162cf6 on S390 I get this one:

Hmm... what are you hibernating to?  A swap device?  A file-backed
swap device?

Thanks,

						- Ted
