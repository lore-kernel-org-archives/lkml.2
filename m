Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2JCErU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:47:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56053 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2JCErL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1210022124060.15182@tundra.namei.org>
References: <alpine.LRH.2.02.1210022124060.15182@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Oct 2012 21:46:48 -0700
X-Google-Sender-Auth: Hcf6SwYtkdon6oY8jMzEglhnrT4
Message-ID: <CA+55aFzfrzmOdJ-wQeSx5r-nin-J-tUCcyCGZ5xauF07UXL7cQ@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.7
To: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 4:35 AM, James Morris <jmorris@namei.org> wrote:
> Highlights:
>
> - Integrity: add local fs integrity verification to detect offline attacks
> - Integrity: add digital signature verification

Ok, the integrity changes in particular clashed with the new user
namespace support by Eric Biederman.

The clashes weren't all that big, but there have been semantic changes
in this area, and I'd like Eric to please check that I resolved it
correctly, and the integrity people to double-check my changes to the
"fowner" field.

Mimi, Dmitry, Eric? Please check my current git tree, in particular
the security/integrity/ima/ima_policy.c file, but I think Eric should
look at the kernel/auditsc.c merge too, in case I missed something.

            Linus
