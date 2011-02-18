Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1BSAAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:00:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab1BSAAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:01 -0500
Date: Fri, 18 Feb 2011 15:59:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 1/9] Add a user_namespace as creator/owner of
 uts_namespace
Message-Id: <20110218155912.ed4116ce.akpm@linux-foundation.org>
In-Reply-To: <20110217150257.GA26395@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150257.GA26395@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:02:57 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> +/*
> + * userns count is 1 for root user, 1 for init_uts_ns,
> + * and 1 for... ?
> + */

?
