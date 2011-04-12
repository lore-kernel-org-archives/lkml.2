Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1DLPgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab1DLPgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:36:13 -0400
Message-ID: <4DA47168.7050105@redhat.com>
Date: Tue, 12 Apr 2011 11:36:08 -0400
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCHv2] fix regression caused by	e48672fa25e879f7ae21785c7efd187738139593
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz> <4D77F149.8020906@redhat.com> <20110309223651.GC1762@pcnci.linuxbox.cz> <4D8C503D.6000607@redhat.com> <20110411161240.GA2332@nik-comp.lan>
In-Reply-To: <20110411161240.GA2332@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 12:12 PM, Nikola Ciprich wrote:
> Hello Zachary,
> what is the current status, are You going to post this patch to Avi?
> I'd like to see one (or both) in stable eventually, I think it's good candidate..
> BR
> nik
>    

I think for upstream the newer patch is the way to go, but I would like 
to see it get some exposure first as it did change locking I think in 
one place.

I'm travelling right now with limited time and network access, difficult 
to resend that patch, but Avi, can you apply it to your tree?

Thanks,

Zach
