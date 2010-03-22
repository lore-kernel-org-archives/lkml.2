Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0CVR1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:27:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17189 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0CVR1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xeUc1+GQMyBZAAqs8EPVVotqUI6bYZD5nGP8TOGcSHe013dVddxbZAO2msDbIqtlg4
         mAsP9GYgGvkGlV6lz709pLJvjfbZhHlGNntEbRoZGozJ3HYpIDPuWa4K9ON50wbVsdBU
         A27WIuVXZ9/m4V2hnXZwdRrBgC1OQCfrcFJj8=
MIME-Version: 1.0
In-Reply-To: <y0mmxy0wa1r.fsf@fche.csb>
References: <20100318172805.GB26067@elte.hu> <4BA3747F.60401@codemonkey.ws>
	 <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com>
	 <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org>
	 <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org>
	 <20100322163215.GC18796@elte.hu> <y0mmxy0wa1r.fsf@fche.csb>
Date: Mon, 22 Mar 2010 19:27:06 +0200
X-Google-Sender-Auth: 38f4b447c2bf9ef7
Message-ID: <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joro@8bytes.org>,
       Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Mon, Mar 22, 2010 at 7:17 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
> In your very previous paragraphs, you enumerate two separate causes:
> "repository structure" and "development/maintenance process" as being
> sources of "fun".  Please simply accept that the former is considered
> by many as absolutely trivial compared to the latter, and additional
> verbose repetition of your thesis will not change this.

I can accept that many people consider it trivial but the problem is
that we have _real data_ on kmemtrace and now perf that the amount of
contributors is significantly smaller when your code is outside the
kernel repository. Now admittedly both of them are pretty intimate
with the kernel but Ingo's suggestion of putting kvm-qemu in tools/ is
an interesting idea nevertheless.

It's kinda funny to see people argue that having an external
repository is not a problem and that it's not a big deal if building
something from the repository is slightly painful as long as it
doesn't require a PhD when we have _real world_ experience that it
_does_ limit developer base in some cases. Whether or not that applies
to kvm remains to be seen but I've yet to see a convincing argument
why it doesn't.

                        Pekka
