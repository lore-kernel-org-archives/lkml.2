Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1JROdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:33:25 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34994 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755414Ab1JROdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:33:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: AQE4MLsVM1lCCOKa7QjNp_pAOZtHxAYlEbnDdy_XMUWgonH
 ejSbXXFFivKWbGk1qTK2NjCmntDHYuOui1034INMUnKirqZzB4gEKNY5iHC9
 bfy7qmJeU5GHyEDjFxFhvjE9.zck82LCUCDCpMidMyM8tUqBoEabByXe6V5D
 VWhsj56VAdOyzROp3frvvGYC3Fc6_oYiztuoaufpQMQ_QUggNakXQRzN_Pbf
 dOcDplRhZulzcWJsAumyEjQvIZHGltAR.dF.ot2_57_KkSFbOL6pQ.j_8PwV
 tTNym5ffTGK4DFn8uCQgsPEADhKNHN4Rrq3yzDbKGIWE_GwBVFbgZS41CNGx
 xRMLLqqvR47opZXIR0UMcaVy0KT2zkDdl82E0N049I0_cDcs-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 18 Oct 2011 09:33:21 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
In-Reply-To: <1318908091.23426.52.camel@debian>
Message-ID: <alpine.DEB.2.00.1110180932330.687@router.home>
References: <1318237851.27949.190.camel@debian>  <alpine.DEB.2.00.1110101026080.16264@router.home>  <1318324774.27949.693.camel@debian>  <alpine.DEB.2.00.1110110910480.3388@router.home>  <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
  <alpine.DEB.2.00.1110120910540.26610@router.home> <1318908091.23426.52.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Alex,Shi wrote:

> > I think its good to have it all in a single patch.
> >
>
> I thought over your requirements, but it is difficult for me to know
> lots of fields in kernel, like for xen/kvm/network etc. So, to avoid
> introduce bugs here, could we do this blind changes, and then change
> each of fields and get owner's ack separately.

Well do the obvious (where you can see that interrupts or preemption are
disabled in the function or in a calling function). Leave the rest as is
and provide separate patches for them?
