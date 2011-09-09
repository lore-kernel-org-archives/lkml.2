Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab1IILzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:55:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36118 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622Ab1IILzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:55:20 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, agruen@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 14/26] richacl: Permission mapping functions
In-Reply-To: <23273.1315564570@redhat.com>
References: <1315243548-18664-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <23273.1315564570@redhat.com>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Fri, 09 Sep 2011 17:24:07 +0530
Message-ID: <87ipp23p9c.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11090911-6078-0000-0000-000000865FEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Sep 2011 11:36:10 +0100, David Howells <dhowells@redhat.com> wrote:
> Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > +unsigned int
> > +richacl_want_to_mask(int want)
> 
> unsigned int want?
> 

updated the patch

-aneesh

