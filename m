Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1CRHiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:38:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59489 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab1CRHim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Cfa1+u+ykR1kZGKaTKc8eS2rYSKMitE9WjOU9hBzLHOrDQY9PsK2s2oqgK7oCVpkiF
         FIje7Zy1F3OW8IUJoJpMQVVVVW5354Q2G0I0u7oOQD3W7iZUNUXidSFKPDroFbE4+8V6
         DirIDmxg6LnSi02an2acdF406gmVH+mIYF6qA=
MIME-Version: 1.0
In-Reply-To: <1295110837-3061-1-git-send-email-shawn.bohrer@gmail.com>
References: <20110115162027.GA2552@lintop> <1295110837-3061-1-git-send-email-shawn.bohrer@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 18 Mar 2011 03:38:21 -0400
Message-ID: <AANLkTimhe0t-eSN8EFuk0RYVX1qe5hhvpZa_xTM4sH8b@mail.gmail.com>
Subject: Re: [PATCH 1/3] epoll: initialize slack for negative timeout values
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Davide Libenzi <davidel@xmailserver.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 12:00, Shawn Bohrer wrote:
> When a negative timeout value is passed to epoll the 'slack' variable is
> currently unitialized:
>
> fs/eventpoll.c: In function ‘ep_poll’:
> fs/eventpoll.c:1119: warning: ‘slack’ may be used uninitialized in this function

still in 2.6.38 ? :/
-mike
