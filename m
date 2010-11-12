Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab0KLTaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:30:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932276Ab0KLTaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:30:00 -0500
Date: Fri, 12 Nov 2010 11:29:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] um: mark CONFIG_HIGHMEM as broken
Message-Id: <20101112112904.4b91d140.akpm@linux-foundation.org>
In-Reply-To: <1289517488-17628-1-git-send-email-richard@nod.at>
References: <1289517488-17628-1-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 00:18:08 +0100
Richard Weinberger <richard@nod.at> wrote:

> Currently CONFIG_HIGHMEM is broken on User Mode Linux.
> I'm not sure if it worked ever.
> 

What is "broken" about it?

