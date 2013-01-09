Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3AIBcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:32:09 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:65242 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3AIBcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <1357694895-520-1-git-send-email-walken@google.com>
References: <1357694895-520-1-git-send-email-walken@google.com>
Date: Tue, 8 Jan 2013 17:32:05 -0800
Message-ID: <CANN689EMBPqVCZdTZm1G0PznGpYR6Y5tMUOspE+emHaX=TkVtA@mail.gmail.com>
Subject: Re: [PATCH 0/8] vm_unmapped_area: finish the mission
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, I was supposed to find a more appropriate subject line before
sending this :]

On Tue, Jan 8, 2013 at 5:28 PM, Michel Lespinasse <walken@google.com> wrote:
> These patches, which apply on top of v3.8-rc kernels, are to complete the
> VMA gap finding code I introduced (following Rik's initial proposal) in
> v3.8-rc1.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
