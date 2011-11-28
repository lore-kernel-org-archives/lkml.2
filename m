Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1K1SRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:17:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51181 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1K1SR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:17:28 -0500
Date: Mon, 28 Nov 2011 22:14:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [RFC] Make Yama pid_ns aware
Message-ID: <20111128181443.GA4672@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <20111121191811.GA24039@albatros>
 <20111122181310.GA4235@sergelap>
 <20111122192028.GA10458@albatros>
 <20111122201007.GA21722@sergelap>
 <20111123074510.GA2356@albatros>
 <20111123144928.GA3893@hallyn.com>
 <20111123165549.GB3463@albatros>
 <CAGXu5j+Y6JnTFhw3Fax_MYLvLLBMO5JOHLgaVyBB2LMsOwhUHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+Y6JnTFhw3Fax_MYLvLLBMO5JOHLgaVyBB2LMsOwhUHw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:12 -0800, Kees Cook wrote:
> On Wed, Nov 23, 2011 at 8:55 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > Can we probably leave them in pid ns for now and when user ns is matured
> > just move it from pid ns to user ns?  Is it possible without breaking
> > Yama's ABI (I think so)?
> 
> So it sounds like you'll send a new patch where only ptrace_scope is
> tied to pidns?

Em, no.  I've said we'll leave everything in pid ns for now.  When user
ns is ready, we'll move some options (all of them?) from pid ns to user
ns.  As user interface is kernel.yama.* sysctls and will not be changed
with the migration, ABI would not be broken by this migration.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
