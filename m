Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1KASRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:17:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50045 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab1KASRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:17:35 -0400
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        cascardo@holoscopio.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
In-Reply-To: <4E738B81.2070005@vflare.org>
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
	 <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org>
	 <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org>
	 <4E72284B.2040907@linux.vnet.ibm.com>  <4E738B81.2070005@vflare.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 10:30:15 -0700
Message-ID: <1320168615.15403.80.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11110118-8974-0000-0000-000001508D2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 13:46 -0400, Nitin Gupta wrote:
> I think replacing allocator every few weeks isn't a good idea. So, I
> guess better would be to let me work for about 2 weeks and try the slab
> based approach.  If nothing works out in this time, then maybe xcfmalloc
> can be integrated after further testing.

Hi Nitin,

It's been about six weeks. :)

Can we talk about putting xcfmalloc() in staging now?

-- Dave

