Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1LGOXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab1LGOXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:23:23 -0500
Message-ID: <4EDF76D6.7020800@redhat.com>
Date: Wed, 07 Dec 2011 16:23:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Notify if VMX is already in use
References: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>  <4EDF7590.5060701@redhat.com> <1323267521.4009.11.camel@lappy>
In-Reply-To: <1323267521.4009.11.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 04:18 PM, Sasha Levin wrote:
> On Wed, 2011-12-07 at 16:17 +0200, Avi Kivity wrote:
> > On 12/01/2011 08:30 PM, Sasha Levin wrote:
> > > Currently we silently fail if VMX is already in use by a different
> > > virtualization technology.
> > >
> > > This is bad since it's non-obvious for the user, and its not too uncommon
> > > for users to have several of these installed on same host.
> > >
> > > This patch adds a message to notify the user of the problem.
> > >
> > 
> > Does this actually happen?  With which hypervisor?
>
> vbox
>
> It turns VMX/SVM on when it loads, regardless of whether it's running a
> guest or not.

That's odd.  IIRC when we discussed this with them, they were executing
VMXON/VMXOFF dynamically.  Looks like they changed this.

Anyway, please adjust according to Joerg's comment (and add the word
"using"), and I'll apply.

-- 
error compiling committee.c: too many arguments to function

