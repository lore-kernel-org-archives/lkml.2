Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab0HJNqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 09:46:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0HJNqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 09:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=LA34XTuPGeweTW1qCXieFKmFYCVzTKHXwpoFMpQN0R8ejx8lEWW9DEDJv5GwZr7Urs
         e/AUm08SDqGI4W866yrnzdInxIwFYzgCMTna+Ppdv35UIK/PjrqWyHu6hhiyyj4Gl3kx
         FWT7lbOhDhBNSnG42ZcnAQdpG8j7AaYOcH3so=
Date: Tue, 10 Aug 2010 10:46:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, David Miller <davem@davemloft.net>,
        willy@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: perf build broke by list_head changes...
Message-ID: <20100810134600.GF18824@ghostprotocols.net>
References: <20100809.235746.115919762.davem@davemloft.net>
 <4C6147DE.9050608@tilera.com>
 <20100810124445.GA14843@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810124445.GA14843@merkur.ravnborg.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 10, 2010 at 02:44:45PM +0200, Sam Ravnborg escreveu:
> IMO the patch that moves list_head to types.h is fine.
> And perf needs to learn good manner with respect to
> kernel headers.

Idea is to try to have the perf tools, since they are hosted in the
kernel and developed mostly by people with kernel background, to use
code and practices used in the kernel proper.

It started just keeping private copies, I guess it should get back to
that since the reaction to this kind of same source repo code sharing
was, well, not good :-)

Alternatives?

- Arnaldo
