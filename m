Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1ILWXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 18:23:17 -0400
Received: from fieldses.org ([174.143.236.118]:40763 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1ILWXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 18:23:15 -0400
Date: Mon, 12 Sep 2011 18:23:06 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: David Howells <dhowells@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, agruen@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 00/26] New ACL format for better NFSv4 acl
 interoperability
Message-ID: <20110912222306.GB17483@fieldses.org>
References: <25175.1315572498@redhat.com>
 <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <26458.1315577016@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26458.1315577016@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 03:03:36PM +0100, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > Acked-by: David Howells <dhowells@redhat.com> for all patches generally where
> > I haven't found anything bad.
> 
> Having said that, there's a distinct lack of changes in the Documentation
> directory...

Probably the documentation belongs in man pages.  Which I think they've
done, but alas the git repos (on kernel.org) aren't accesible right
now....

--b.
