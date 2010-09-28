Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0I1PRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:17:49 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36909 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab0I1PRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:17:48 -0400
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org, Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CA1E338.6070201@redhat.com>
References: <4CA0EBEB.1030204@austin.ibm.com>  <4CA1E338.6070201@redhat.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 28 Sep 2010 08:17:36 -0700
Message-ID: <1285687056.19976.6155.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 14:44 +0200, Avi Kivity wrote:
> Why not update sysfs directory creation to be fast, for example by using 
> an rbtree instead of a linked list.  This fixes an implementation 
> problem in the kernel instead of working around it and creating a new ABI.
> 
> New ABIs mean old tools won't work, and new tools need to understand 
> both ABIs.

Just to be clear _these_ patches do not change the existing ABI.

They do add a new ABI: the end_phys_index file.  But, it is completely
redundant at the moment.  It could be taken out of these patches.

That said, fixing the directory creation speed is probably a worthwhile
endeavor too.

-- Dave

