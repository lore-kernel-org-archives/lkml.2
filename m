Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2F1Beo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:34:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36813 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751447Ab2F1Bem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:34:42 -0400
Message-ID: <1340847281.16533.57.camel@joe2Laptop>
Subject: Re: [PATCH next] kvm: Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 18:34:41 -0700
In-Reply-To: <20120628004434.GA18388@amt.cnet>
References: <1339644021.28729.17.camel@joe2Laptop>
	 <20120628004434.GA18388@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 21:44 -0300, Marcelo Tosatti wrote:
> The advantage is the added prefix?

All messages are automatically prefixed.
For instance:

> > -		printk(KERN_WARNING "Fail to find correlated MSI-X entry!\n");
> > +		pr_warn("Fail to find correlated MSI-X entry!\n");

Now has a prefix that describes the module from which
the message originates.

> $ grep limit Documentation/CodingStyle 
> The limit on the length of lines is 80 columns and this is a strongly
> preferred limit.

Read further:

However, never break user-visible strings such as
printk messages, because that breaks the ability to grep for them.

cheers, Joe


