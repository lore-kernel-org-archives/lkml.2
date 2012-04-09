Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DIQ4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:56:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36957 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2DIQ4N convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 9 Apr 2012 12:56:13 -0400
Message-Id: <4F8322BB020000780008229D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 09 Apr 2012 17:56:11 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <david.vrabel@citrix.com>, <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 6/7] xen/setup: Make dom0_mem=XGB
 behavior be similar to classic Xen kernels.
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
 <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
 <4F7ABBC4.4050106@citrix.com> <20120406205909.GA26309@phenom.dumpdata.com>
In-Reply-To: <20120406205909.GA26309@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 04/06/12 11:04 PM >>>
>> With your new behaviour it will no longer possible to specify an
>> unlimited balloon but a limited number of initial pages.  This is
>> behaviour that Jan said he used.
>
>I am not sure I see the problem - I mean if one uses:
>
>dom0_mem=min:8G,max:16G
>
>I understand that we want to start at 8GB and if the user
>choose to - balloon up to 16GB.
>
>But doing this:
>
>dom0_mem=8G
>
>and allocating pagetables up to .. say 32GB, seems counter-intuive
>as the effect is similar to having no 'dom0_mem' except that the initial
>size is smaller.

What's counter intuitive here? There may not be a need - from the perspective
of the kernel - for a hard upper limit enforced by Xen (i.e. the pseudo infinity
we have right now may be quite fine).

Anyway, as said in the other reply already - unless this is to address a bug, I
don't see the point in changing behavior that has been that way for a pretty
long time.

Jan

