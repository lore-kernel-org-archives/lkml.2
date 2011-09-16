Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1IPSdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:33:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43743 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab1IPSde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:33:34 -0400
Message-ID: <4E739677.4020708@linux.vnet.ibm.com>
Date: Fri, 16 Sep 2011 13:33:27 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
        dan.magenheimer@oracle.com, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        linux-mm@kvack.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org> <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org> <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org> <4E72284B.2040907@linux.vnet.ibm.com> <4E738B81.2070005@vflare.org>
In-Reply-To: <4E738B81.2070005@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 12:46 PM, Nitin Gupta wrote:
> I think replacing allocator every few weeks isn't a good idea. So, I
> guess better would be to let me work for about 2 weeks and try the slab
> based approach.  If nothing works out in this time, then maybe xcfmalloc
> can be integrated after further testing.

Sounds good to me.

> 
> Thanks,
> Nitin
> 

Thanks
--
Seth

