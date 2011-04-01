Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1DAHGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:06:23 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:41030 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1DAHGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:06:21 -0400
Message-ID: <4D95799C.6040809@de.ibm.com>
Date: Fri, 01 Apr 2011 09:07:08 +0200
From: Carsten Otte <carsteno@de.ibm.com>
Organization: =?windows-1252?Q?IBM_Deutschland_Research_=26_Devel?=
 =?windows-1252?Q?opment_GmbH=2CVorsitzender_des_Aufsichtsrats=3A_?=
 =?windows-1252?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Dirk_Witt?=
 =?windows-1252?Q?kopp=2CSitz_der_Gesellschaft=3A_B=F6blingen=2CReg?=
 =?windows-1252?Q?istergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?windows-1252?Q?3294?=
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110307 Lightning/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Pekka Enberg <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "joro@8bytes.org Roedel" <joro@8bytes.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Asias He <asias.hejun@gmail.com>, gorcunov@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Carsten Otte <cotte@de.ibm.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <1B1AE097-4524-4026-85EC-F9A0E274FFF2@suse.de>
In-Reply-To: <1B1AE097-4524-4026-85EC-F9A0E274FFF2@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.03.2011 23:47, Alexander Graf wrote:
> Did you take a look at kuli?
Right. If you want to take kuli as a start, and GPL is acceptable for 
you ;-).
If kuli seems right, I suggest to go ahead and make an upstream git 
repository for it. I'd be happy to keep contributing the s390 parts to 
whoever feels responsible for maintaining the tree.

cheers,
Carsten




