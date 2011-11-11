Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab1KKTWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:22:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58025 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1KKTWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:22:44 -0500
Date: Fri, 11 Nov 2011 11:22:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julie Sullivan <kernelmail.jms@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Shaohua Li <shaohua.li@intel.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: INFO: possible recursive locking detected: get_partial_node()
 on 3.2-rc1
Message-ID: <20111111192211.GE2283@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111109090556.GA5949@zhy>
 <201111102335.06046.kernelmail.jms@gmail.com>
 <1320980671.22361.252.camel@sli10-conroe>
 <alpine.DEB.2.00.1111110857330.3557@router.home>
 <CAAVPGOPwKV12TqwU1DcxvJTW9dsmWNiNFg4ga7PzWNgQ2M=1RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVPGOPwKV12TqwU1DcxvJTW9dsmWNiNFg4ga7PzWNgQ2M=1RQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111119-5806-0000-0000-000003AD03DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 07:09:01PM +0000, Julie Sullivan wrote:
> It's probably moot now but FWIW I checked Shaohua's patch too and it
> got rid of the warning in my dmesg.

Thank you both for your testing efforts!  Hopefully there will be
a more permanent fix soon.

							Thanx, Paul

