Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1CPFel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:34:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43893 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1CPFed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=luZH07GyUnHwXLMClmBJ4aj6YH1qA9WkcbL6BodqAtattERCERmed5oxSiTRlaH+L/
         9MgnAs9Q6ZhGbg11X+9cyU/tV8N+fMrv0FkbeQn0BqcmznS6U2TEWrdj1nxFzc/mTeVn
         o+j2BAu0BbKPIYqoWjT8aGPXReOKZ3T6ypJxc=
Date: Tue, 15 Mar 2011 22:34:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, dgdegra@tycho.nsa.gov
Subject: Re: [PATCH 2/4] xen-kbdfront: Add grant reference for shared page
Message-ID: <20110316053426.GB14604@core.coreip.homeip.net>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
 <1300198274-1325-3-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300198274-1325-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:11:13AM -0400, Konrad Rzeszutek Wilk wrote:
> From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> 
> Without a grant reference, full access to the domain's memory is
> required to use the shared page. Add an additional parameter in
> xenstore to allow grant mapping to be used.
> 
> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

You are passing the patch on so it should be Signed-off-by...

It is independent of the other 2 so I can pick it up and merge (so that
we do not have conflicts with move), right?

-- 
Dmitry
