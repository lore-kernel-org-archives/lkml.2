Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab2C3NHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:07:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36185 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760372Ab2C3NHP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 30 Mar 2012 09:07:15 -0400
Message-Id: <4F75BE0E0200007800081A61@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 30 Mar 2012 14:07:10 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <x86@kernel.org>, <richard@nod.at>
Cc: <jeremy@goop.org>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: spinlock.h: Remove REG_PTR_MODE
References: <1333064283-3109-1-git-send-email-richard@nod.at>
In-Reply-To: <1333064283-3109-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Richard Weinberger <richard@nod.at> 03/30/12 1:34 AM >>>
>REG_PTR_MODE has no users at all.
>
>Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Jan Beulich <jbeulich@suse.com>

