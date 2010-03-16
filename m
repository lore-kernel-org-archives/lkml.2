Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937960Ab0CPR31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:29:27 -0400
Received: from claw.goop.org ([74.207.240.146]:54317 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919Ab0CPR30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:29:26 -0400
Message-ID: <4B9FBFF3.4090806@goop.org>
Date: Tue, 16 Mar 2010 10:29:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM
 initialization
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>	 <alpine.DEB.2.00.1003151108151.27222@kaball-desktop>	 <4B9EBBEE.9020107@goop.org> <201003160951.48973.sheng@linux.intel.com>	 <4B9FBBEA.2060508@goop.org> <1268760010.10129.31253.camel@zakaz.uk.xensource.com>
In-Reply-To: <1268760010.10129.31253.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 10:20 AM, Ian Campbell wrote:
> I don't think a new hypercall is required. Xen should simply pre-account
> for the TSC offset which HVM guests are subject to in
> __update_vcpu_system_time.
>    

Yes, that would work too.

     J
