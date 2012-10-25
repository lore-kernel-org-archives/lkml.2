Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132Ab2JYOLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759008Ab2JYOK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:10:59 -0400
Date: Thu, 25 Oct 2012 10:10:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: Kdump with signed images
Message-ID: <20121025141048.GD9377@redhat.com>
References: <874nlrv2ni.fsf@xmission.com>
 <20121019020630.GA27052@redhat.com>
 <877gqnnnf0.fsf@xmission.com>
 <20121019143112.GB27052@redhat.com>
 <871ugqb4gj.fsf@xmission.com>
 <20121023131854.GA16496@redhat.com>
 <20121023145920.GD16496@redhat.com>
 <87fw552mb4.fsf_-_@xmission.com>
 <20121024173651.GE1821@redhat.com>
 <1351145401.18115.78.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351145401.18115.78.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:10:01AM -0400, Mimi Zohar wrote:

[..]
> IMA-appraisal verifies the integrity of file data, while EVM verifies
> the integrity of the file metadata, such as LSM and IMA-appraisal
> labels.  Both 'security.ima' and 'security.evm' can contain digital
> signatures.

But the private key for creating these digital signature needs to be
on the target system?

Thanks
Vivek
