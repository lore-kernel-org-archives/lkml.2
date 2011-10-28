Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab1J1Wy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 18:54:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab1J1Wy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 18:54:57 -0400
Date: Fri, 28 Oct 2011 15:54:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] cache align vm_stat
Message-Id: <20111028155456.20f3d611.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1110262131240.27107@router.home>
References: <20111024161035.GA19820@sgi.com>
	<alpine.DEB.2.00.1110262131240.27107@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011 21:31:46 -0500 (CDT)
Christoph Lameter <cl@gentwo.org> wrote:

> On Mon, 24 Oct 2011, Dimitri Sivanich wrote:
> 
> > Avoid false sharing of the vm_stat array.

Did we have some nice machine-description and measurement results which
can be included in the changelog?  Such things should always be
included with a performace patch!

> Acked-by: Christoph Lameter <cl@gentwo.org>

Do christoph@lameter.com, cl@linux-foundation.org and cl@linux.com still work?
