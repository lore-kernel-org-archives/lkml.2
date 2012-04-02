Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2DBSCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:02:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35324 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2DBSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <4F79E83C.5090506@amd.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	<1333102459-23750-1-git-send-email-lenb@kernel.org>
	<1a022e3f1be11730bd8747b1af96a0274bf6356e.1333101989.git.len.brown@intel.com>
	<CA+8MBbLROfbyfAGZ0xn1tZVHsndeTUNrn=-gHhsfzkocBLh=iQ@mail.gmail.com>
	<CA+8MBbJnrhKmy5f_pbL8Ogi1ihM-51hfqCDY5gUQ1hkvw7p22Q@mail.gmail.com>
	<4F79E83C.5090506@amd.com>
Date: Mon, 2 Apr 2012 11:02:44 -0700
Message-ID: <CA+8MBbKv25Uu3fJeBhyj5cQvB6FN+KqgnP67UGhwvF+p635g7w@mail.gmail.com>
Subject: Re: [PATCH 58/76] idle, x86: Allow off-lined CPU to enter deeper C states
From: Tony Luck <tony.luck@gmail.com>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> x86 halt() causes processor to go to C1 state (which is often not the
> deepest). But other than that it seems similar to what you are describing.

OK - then Konrad's suggestion of using "safe_halt()" here rather than
"halt()" would work for ia64.

Other architectures don't use APCI - so this should just be localized to
x86 and ia64

-Tony
