Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1BAV0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:26:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48809 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1BAV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:26:12 -0500
Date: Tue, 1 Feb 2011 15:26:05 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Steve Grubb <sgrubb@redhat.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] System Wide Capability Bounding Set
Message-ID: <20110201212605.GB5294@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
 <201101270942.07689.sgrubb@redhat.com>
 <20110128184901.GA5134@localhost>
 <201101281410.29794.sgrubb@redhat.com>
 <20110128193809.GB8854@localhost>
 <1296584221.3145.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296584221.3145.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> What are we thinking?  Any suggestions how to do what we need other than
> 
> global bounding such that  pP' = gbset & (fI | pI)

That should be sufficient for what you want.

I would however like to hear whether Andrew has had any other ideas
given the broader picture.

> Or an interface in which I can force things out of the bset and pI of
> other tasks?  Possibly the interface could be specific to the "khelper"
> thread?

No no no no no :)

thanks,
-serge
