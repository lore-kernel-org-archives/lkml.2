Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985Ab0JIA2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab0JIA2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:28:41 -0400
Date: Fri, 8 Oct 2010 20:28:31 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, jmoyer@redhat.com, linux-fs@vger.kernel.org,
        autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 08/17] Make follow_down() handle d_manage()
Message-ID: <20101009002831.GG30846@shell>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk> <20100930181536.30939.6776.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930181536.30939.6776.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 07:15:36PM +0100, David Howells wrote:
>  }
>  
>  /*
> + * Follow down to the topmost point on a stack of mountpoints.  At each point,

"Follow down to the topmost" -> "Follow down to covering mount" ?

-VAL
