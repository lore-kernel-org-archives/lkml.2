Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1DZS5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:57:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab1DZS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:57:35 -0400
Date: Tue, 26 Apr 2011 11:56:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: dave@linux.vnet.ibm.com, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Subject: Re: [PATCH 1/3] flex_array: flex_array_prealloc takes a number of
 elements, not an end
Message-Id: <20110426115638.379068b1.akpm@linux-foundation.org>
In-Reply-To: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 21:45:31 -0400
Eric Paris <eparis@redhat.com> wrote:

> Change flex_array_prealloc to take the number of elements for which space
> should be allocated instead of the last (inclusive) element. Users
> and documentation are updated accordingly.

Why?
