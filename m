Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2JSLlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:41:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:47517 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2JSLlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:41:14 -0400
Message-ID: <1350646863.30157.13.camel@twins>
Subject: Re: [PATCH 2/2] rename NUMA fault handling functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Date: Fri, 19 Oct 2012 13:41:03 +0200
In-Reply-To: <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
	 <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 17:20 -0400, Rik van Riel wrote:
> Having the function name indicate what the function is used
> for makes the code a little easier to read.  Furthermore,
> the fault handling code largely consists of do_...._page
> functions. 

I don't much care either way, but I was thinking walken might want to
use something similar to do WSS estimation, in which case the NUMA name
is just as wrong.


