Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2LQTDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:03:32 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33564 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2LQTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:03:31 -0500
MIME-Version: 1.0
In-Reply-To: <87txroxpgq.fsf@xmission.com>
References: <87txroxpgq.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 11:03:10 -0800
Message-ID: <CALCETrX2Fa-DuM+wkgsij7oiJXzCD8W6Phkv-MjgCDg_Ma6CTg@mail.gmail.com>
Subject: Re: [PATCH 0/4] user namespace fixes
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 2:01 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> These are fixes from Andys review of my user namespace tree.
>
> The first two patches are critical must fix fixes.
>
> The third patch fixing commit_creds is a nice to have but fixing it
> would be good.
>
> Andy, Serge  if you could give these patches a once over to make certain
> I am not doing something stupid.
>
> Thank you,
> Eric
>
> ---
>
> Eric W. Biederman (4):
>       Fix cap_capable to only allow owners in the parent user namespace to have caps.

For whatever reason, I didn't get the actual email.  Assuming this is
5e4a08476b50fa39210fca82e03325cc46b9c235:

Acked-by: Andy Lutomirski <luto@amacapital.net>

However, this comment:
                /*
                 * The owner of the user namespace in the parent of the
                 * user namespace has all caps.
                 */
could use work.  I agree with the code, but I gave up on understanding
the comment.

>       userns:  Require CAP_SYS_ADMIN for most uses of setns.
>       userns: Add a more complete capability subset test to commit_creds
>       userns: Fix typo in description of the limitation of userns_install
>

--Andy
