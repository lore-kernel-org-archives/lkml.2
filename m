Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1CIXDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:03:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908Ab1CIXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:03:09 -0500
Date: Wed, 9 Mar 2011 15:03:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: make struct proc_dir_entry::namelen unsigned int
Message-Id: <20110309150306.90369913.akpm@linux-foundation.org>
In-Reply-To: <20110308105428.GA5767@p183.telecom.by>
References: <20110308105428.GA5767@p183.telecom.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011 12:54:28 +0200
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Space is not really conserved, because of natural alignment for the next field.
> sizeof(struct proc_dir_entry) remains the same.
> 

What is the reason for this patch??

