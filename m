Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0CRNB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:01:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:43466 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0CRNBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i+d4bQGELjnAbu/wGVu/Y5bcbpPsSsFlmZ0p72EgqOnX1GI0dVkRAgMeEtB4XEYDfk
         fM0k+Oxj0iUReDDZhJSjjtfE8ymz8A++cBXNZ+a2L3GotgRsIQJioqhzawoLzCWJdQlD
         PPw7TUlUekp6vvevY5u8+RlJfiw6lECOEUuc0=
MIME-Version: 1.0
In-Reply-To: <y0m4okdzu4z.fsf@fche.csb>
References: <20100316130840.GA24808@elte.hu> <4BA00F1F.1090907@codemonkey.ws>
	 <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com>
	 <20100318085607.GB2157@elte.hu>
	 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
	 <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com>
	 <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb>
Date: Thu, 18 Mar 2010 14:01:11 +0100
X-Google-Sender-Auth: 935b4a6e9d214fb7
Message-ID: <520f0cf11003180601k3a08d77ej24b98f833c8d1a9a@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: John Kacur <jkacur@redhat.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 1:33 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
> Ingo Molnar <mingo@elte.hu> writes:
>
>> [...]
>> Distributions are very eager to update kernels even in stable periods of the
>> distro lifetime - they are much less willing to update user-space packages.
>> [...]
>
> Sorry, er, what?  What distributions eagerly upgrade kernels in stable
> periods, were it not primarily motivated by security fixes?  What users
> eagerly replace their kernels?
>

Us guys reading and participating on the list. ;)
