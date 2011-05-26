Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab1EZSMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:12:12 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:34101 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab1EZSMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:12:10 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: David Safford <safford@watson.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
In-Reply-To: <4DDE80FE.7010005@schaufler-ca.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110518172552.6d482c7a.akpm@linux-foundation.org>
	 <20110526060842.GA13933@localhost.ucw.cz>
	 <4DDE80FE.7010005@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 14:11:54 -0400
Message-ID: <1306433514.24986.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 09:34 -0700, Casey Schaufler wrote:
> On 5/25/2011 11:08 PM, Pavel Machek wrote:
> > ...
> > Fourthly, is it likely to find its way to the next cellphone I buy,
> > and will it prevent me from rooting it?
> > 								Pavel
> 
> That will of course depend on the phone vendor. You are certainly
> going to be able to vote with your checkbook (digital wallet?) but
> odds are pretty good that should EVM prove effective it will be
> ubiquitous within the next five years on embedded devices.

um, not quite the right threat model...

Rooting is normally done through an exploit of the loader
or the kernel, neither of which EVM can prevent. The phones
which have blocked rooting in hardware have done so by adding
and enforcing digital signatures on the boot images, which is
entirely orthogonal to EVM.

Whether or not the phone is rooted, IMA-Appraisal, EVM, and 
the Digital Signature Extensions help protect against remote
software attacks, and offline hardware attacks on individual
files, but not against rooting itself.

dave
(happy owner of a rooted Droid)
