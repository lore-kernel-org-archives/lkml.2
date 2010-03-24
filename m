Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0CXMG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:06:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:33048 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab0CXMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tdQRIWpOii8x3caQa6I6dCCsdgwqUzACt8lKSqH4ZLpEpe8ylzqQfYOv2T508ziCeb
         /YynijMu9rr350F9EokmEOthUjGVRMyBL4wlXG0Ecdh6hQcE+P8Rwt0rSgl+HyKR7C+d
         2xQLn7zrvsDYtVilZopP83AOW22fok3MsnXqc=
Message-ID: <4BAA0038.6010705@redhat.com>
Date: Wed, 24 Mar 2010 13:06:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com>
In-Reply-To: <4BA7187E.3050405@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 08:13 AM, Avi Kivity wrote:
>
> (btw, why are you interested in desktop-on-desktop?  one use case is
> developers, which don't really need fancy GUIs; a second is people who
> test out distributions, but that doesn't seem to be a huge population;
> and a third is people running Windows for some application that doesn't
> run on Linux - hopefully a small catergory as well.

This third category is pretty well served by virt-manager.  It has its 
quirks and shortcomings, but at least it exists.

Paolo
