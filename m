Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1DZS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:58:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab1DZS6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:58:34 -0400
Date: Tue, 26 Apr 2011 11:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: dave@linux.vnet.ibm.com, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Subject: Re: [PATCH 3/3] flex_array: allow 0 length elements
Message-Id: <20110426115756.cb501eb4.akpm@linux-foundation.org>
In-Reply-To: <20110426014543.1740.89115.stgit@paris.rdu.redhat.com>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
	<20110426014543.1740.89115.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 21:45:43 -0400
Eric Paris <eparis@redhat.com> wrote:

> allow elements of 0 length.  We already allow flex_arrays with 0 elements, but
> this patch allow us to have elements that are 0 bytes long.

Again, sounds vaguely useful but it adds code and churns the code for
no apparent benefit.

IOW2: why?
