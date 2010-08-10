Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0HJMKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:10:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49866 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0HJMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:09:55 -0400
Message-ID: <4C61419B.9040409@infradead.org>
Date: Tue, 10 Aug 2010 09:10:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100803 Red Hat/3.1.2-1.el6 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] docbook: fixup media support files for htmldocs also
References: <20100809163040.137c6571.randy.dunlap@oracle.com>
In-Reply-To: <20100809163040.137c6571.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-08-2010 20:30, Randy Dunlap escreveu:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> 'make htmldocs' produces errors due to missing a supporting media
> file, so add 'xmldoclinks' to the htmldocs dependencies so that the
> needed supporting file will be present.
> 
> linux-2.6.35-git8/DOC1/Documentation/DocBook/media.xml:4: warning: failed to load external entity "linux-2.6.35-git8/DOC1/Documentation/DocBook/media-entities.tmpl"
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Mauro Carvalho Chehab <mchehab@infradead.org>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Documentation/DocBook/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.35-git8.orig/Documentation/DocBook/Makefile
> +++ linux-2.6.35-git8/Documentation/DocBook/Makefile
> @@ -45,7 +45,7 @@ PDF := $(patsubst %.xml, %.pdf, $(BOOKS)
>  pdfdocs: $(PDF)
>  
>  HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
> -htmldocs: $(HTML)
> +htmldocs: $(HTML) xmldoclinks
>  	$(call build_main_index)
>  	$(call build_images)
>  
> ---

