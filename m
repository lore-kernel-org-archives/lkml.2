Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0CRFld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 01:41:33 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:49578 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab0CRFlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 01:41:31 -0400
Message-ID: <4BA1BD08.4020401@msgid.tls.msk.ru>
Date: Thu, 18 Mar 2010 08:41:28 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Dieter Ries <mail@dieterries.net>
CC: Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com> <4BA1504A.3090801@dieterries.net> <808FF008-53B9-4271-904C-117A24ADF18C@suse.de> <20100317224002.GA5156@Localhorst.asterix.local>
In-Reply-To: <20100317224002.GA5156@Localhorst.asterix.local>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries wrote:
> On Wed, Mar 17, 2010 at 11:02:40PM +0100, Alexander Graf wrote:
[]
>> Are you 100% sure you don't have vmware, virtualbox, parallels, whatever running in parallel on that machine?
> 
> Definitely. I have virtualbox installed, but haven't used it in months.
> The others I don't use at all, so they are not installed either.

Dieter, we've talked with you on IRC yesterday...

Can you take a look at what's in the startup script sequence on
your machine, and what modules are loaded which may be related?
What I'm trying to say: I don't know how virtualbox works, but it
may come with a kernel module or a bootup script that touches SVM
settings.

/mjt
