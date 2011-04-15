Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1DOUhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:37:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1DOUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lnhsn0xA6kS17/4qDzMhy1ndbX99d6TM1z7csAINh6/i615n9+/VUoxYdMOR1KvCKo
         3SH4oi1sh92fjyDdE48A==
Date: Fri, 15 Apr 2011 13:36:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <andi.kleen@intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: RE: [0/7,v10] NUMA Hotplug Emulator (v10)
In-Reply-To: <749B9D3DBF0F054390025D9EAFF47F224A605265@shsmsx501.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1104151335380.29956@chino.kir.corp.google.com>
References: <749B9D3DBF0F054390025D9EAFF47F224A3D6C35@shsmsx501.ccr.corp.intel.com> <749B9D3DBF0F054390025D9EAFF47F224A605265@shsmsx501.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Zhang, Yang Z wrote:

> Any comments for those patches?
> 

I believe I commented on them in 
http://marc.info/?l=linux-kernel&m=130272108421404 :)
