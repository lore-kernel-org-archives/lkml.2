Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0DWTSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:18:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:39641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0DWTSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:18:42 -0400
Subject: Re: [PATCH 0/8] More fixes for nested svm
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4BD02D45.4030905@redhat.com>
Date: Fri, 23 Apr 2010 21:18:39 +0200
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8A94B9D4-7DF2-4D54-AB27-9E1946958089@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <4BD02D45.4030905@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2010, at 13:04, Avi Kivity wrote:

> On 04/22/2010 01:33 PM, Joerg Roedel wrote:
>> Hi Avi, Marcelo,
>> 
>> here is another set of nested svm fixes. They fix NMI code to make UP Hyper-V
>> root domain booting. The patches also add better handling for nested entry
>> failures and mce intercepts.
>> Also in this patchset are the fixes for the supported cpuid reporting for svm
>> features. These patches were taken from the nested-npt patchset and slightly
>> modified. These patches are also marked for -stable backporting.
>> The probably most important fix is about exception reinjection. This didn't
>> work reliably before and is fixed with the patch in this series now. This fix
>> also touches common x86 code but that should be ok because it could be reused
>> by nested-vmx later.
>> Please review and give comments (or apply ;-).
>>   
> 
> Looks good.  I'll wait a day or two for more reviews (esp. Alex).

No complaints from me.


Alex

