Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1KPLA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:00:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56032 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab1KPLAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:00:55 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockdep: Don't disable lockdep for out of tree modules
In-Reply-To: <1321433203.1421.69.camel@twins>
References: <1321429835-1466-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1321433203.1421.69.camel@twins>
User-Agent: Notmuch/0.9+73~ged20210 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 16 Nov 2011 16:30:28 +0530
Message-ID: <87obwcl4c3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11111611-3270-0000-0000-000001CCAE39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 09:46:43 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-11-16 at 13:20 +0530, Aneesh Kumar K.V wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > I guess it would be nice to get lockdep enabled for out of tree GPL modules
> 
> How about you get them in staging instead?
> 

I actually wanted to do a sample module to demo lockdep in one of the
presentation i am doing and that is when i hit the issue. I don't have
a kernel module that i would like to keep out of tree. I am not sure
there is any value in disabling lockdep if one load an out of tree GPL
kernel module.

-aneesh

