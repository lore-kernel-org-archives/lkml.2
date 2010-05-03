Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0ECNYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:24:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:54138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188Ab0ECNYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:24:36 -0400
Subject: RE: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
 for scsi device(This is correct revision, please ignore last one)
From: James Bottomley <James.Bottomley@suse.de>
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <543391074648471F8A10624BAC48E286@areca4e4f859d4>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4>
	 <1272891585.4369.15.camel@mulgrave.site>
	 <543391074648471F8A10624BAC48E286@areca4e4f859d4>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 09:24:31 -0400
Message-ID: <1272893071.4369.24.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 21:17 +0800, Nick Cheng wrote:
> Hi James,
> It seems you set CONFIG_SCSI_ARCMSR_AER.
> Could you undefine it?

Config option testing is part of the stuff I run through.  Even if I
undefine it, one of the many people who run automated config testing
will pick it up ... and then I'll get email about it.

> I will remove this section.

Thanks.

James


