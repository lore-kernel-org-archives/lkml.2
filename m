Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2KQCqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 21:46:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58221 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2KQCqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 21:46:40 -0500
Date: Fri, 16 Nov 2012 18:43:26 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] ramoops: Fixup section annotations
Message-ID: <20121117024325.GB29966@lizard>
References: <1350459589-55210-1-git-send-email-hare@suse.de>
 <CAGXu5jJ+tUt0+q0Mt8YPexVPesZW+eV64rypDia+NJDneR8_Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+tUt0+q0Mt8YPexVPesZW+eV64rypDia+NJDneR8_Qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:53:33AM -0700, Kees Cook wrote:
> On Wed, Oct 17, 2012 at 12:39 AM, Hannes Reinecke <hare@suse.de> wrote:
> > The compiler complained about missing section annotations.
> > Fix it.
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> > Cc: Colin Cross <ccross@android.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Tony Luck <tony.luck@intel.com>
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Applied, thank you!
