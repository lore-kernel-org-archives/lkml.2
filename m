Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1J1Rw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:58432 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1J1Rw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:27 -0400
Subject: Re: [RFC][PATCH 2/2] Example to show use of uio pgprot
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20111028163706.GB27444@kroah.com>
Date: Fri, 28 Oct 2011 12:52:01 -0500
Cc: hjk@hansjkoch.de, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A42590B4-A0D4-433D-ADA8-57ECBFAB9A6E@kernel.crashing.org>
References: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org> <1319817030-23992-2-git-send-email-galak@kernel.crashing.org> <20111028163706.GB27444@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2011, at 11:37 AM, Greg KH wrote:

> On Fri, Oct 28, 2011 at 10:50:30AM -0500, Kumar Gala wrote:
>> ---
>> drivers/uio/uio_dpa.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++
>> 1 files changed, 200 insertions(+), 0 deletions(-)
>> create mode 100644 drivers/uio/uio_dpa.c
> 
> You do realize this does not build, right?
> 
> thanks,
> 
> greg k-h

Yes, it was meant to show Hans and example of why we need to allow a UIO driver to set its own pgprot.  We plan on upstream all that code, but wanted at least to get feedback on the general UIO change.

- k