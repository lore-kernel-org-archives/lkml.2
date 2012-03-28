Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab2C1QgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507Ab2C1QgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:36:20 -0400
Message-ID: <4F733DFD.2030107@redhat.com>
Date: Wed, 28 Mar 2012 18:36:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: dave@gnu.org
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: add paging gcc optimization
References: <1331207154.28711.2.camel@offworld>  <4F58D48F.8050807@de.ibm.com>  <4F5DE84B.8050606@redhat.com> <1332539514.2580.0.camel@offbook>
In-Reply-To: <1332539514.2580.0.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 11:51 PM, Davidlohr Bueso wrote:
> Avi, will you be taking this patch? I don't see it applied or for pull
> in 3.4.
>
>

Applied now, thanks for the reminder.

-- 
error compiling committee.c: too many arguments to function

