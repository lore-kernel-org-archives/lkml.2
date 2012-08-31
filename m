Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2HaO51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:57:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2HaO50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:57:26 -0400
Date: Fri, 31 Aug 2012 16:57:25 +0200
From: Michal Marek <mmarek@suse.cz>
To: Adam Lee <adam8157@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "open list:KCONFIG" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] [Signed-off] kconfig: document oldnoconfig to what it
 really does in conf.c
Message-ID: <20120831145725.GE11531@sepie.suse.cz>
References: <1345186649-17502-1-git-send-email-adam8157@gmail.com>
 <20120822134519.GA5639@adam-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822134519.GA5639@adam-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 09:45:19PM +0800, Adam Lee wrote:
> On Fri, Aug 17, 2012 at 02:57:28PM +0800, Adam Lee wrote:
> > As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, the make target
> > 'oldnoconfig' is a misnomer. It doesn't set new symbols to 'n', but
> > instead sets it to their default values.
> > 
> > This patch fixes the document in conf.c, and will submit another patch
> > to replace 'oldnoconfig' to 'olddefconfig'
> > 
> > Signed-off-by: Adam Lee <adam8157@gmail.com>
> > ---
> >  scripts/kconfig/conf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Hi,
> 
> I think we should apply this patch, any comment?

Sorry for the delay. I applied it to kbuild.git#kconfig now.

Michal
