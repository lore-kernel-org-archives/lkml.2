Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1DUTot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:44:49 -0400
Received: from mail.perches.com ([173.55.12.10]:4885 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1DUTos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:44:48 -0400
Subject: Re: annoying new gcc 4.6.0 warnings.
From: Joe Perches <joe@perches.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
In-Reply-To: <4DB087EC.1010205@caviumnetworks.com>
References: <20110421192117.GA14249@redhat.com>
	 <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
	 <4DB087EC.1010205@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 12:44:46 -0700
Message-ID: <1303415086.24766.84.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 12:39 -0700, David Daney wrote:
> Would it make any sense to add a config option to enable the spew for 
> those that wanted to see it?

Add it to make W=1 instead?
See commit 4a5838ad9d2d

