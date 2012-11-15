Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767802Ab2KONZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:25:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43621 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767745Ab2KONZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:25:58 -0500
Date: Thu, 15 Nov 2012 13:25:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Geremy Condra <gcondra@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v5 0/4] arch/arm: support seccomp
Message-ID: <20121115132550.GA5570@mudshark.cambridge.arm.com>
References: <1352587485-18348-1-git-send-email-keescook@chromium.org>
 <CAGXu5jKYGCkL3GS4Tbep==WUAqP-c_0edAdgy0XQ84rJxZUU2Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKYGCkL3GS4Tbep==WUAqP-c_0edAdgy0XQ84rJxZUU2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Nov 2012 13:25:54.0180 (UTC) FILETIME=[BD181440:01CDC334]
X-MC-Unique: 112111513255603201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 07:07:13PM +0000, Kees Cook wrote:
> Hi, any more thoughts on this series? I'd really like to get it into
> -next. It's been running happily for a while now in the Chrome OS ARM
> devices.

I'm not familiar with seccomp in general, but the changes look ok now from
an ARM point-of-view:

  Reviewed-by: Will Deacon <will.deacon@arm.com>

These should probably go via Russell (who will put them into -next), so
please send them to the patch system.

Will

