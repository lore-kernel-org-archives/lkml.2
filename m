Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2LYQ7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:59:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab2LYQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:59:53 -0500
Date: Tue, 25 Dec 2012 17:59:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH review 2/3 take 2] pidns: Stop pid allocation when init
	dies
Message-ID: <20121225165954.GB9066@redhat.com>
References: <87d2y2elbi.fsf@xmission.com> <871ueiel9d.fsf@xmission.com> <20121222165438.GA19680@redhat.com> <87licm7d4n.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87licm7d4n.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25, Eric W. Biederman wrote:
>
> Avoid these problems by disabling the allocation of new pids in a pid
> namespace when init dies, instead of when the last process in a pid
> namespace is reaped.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

