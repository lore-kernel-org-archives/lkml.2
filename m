Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1JRDnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1JRDnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:43:40 -0400
Subject: Re: module-init-tools development repo
From: Jon Masters <jcm@redhat.com>
To: Shea Levy <shea@shealevy.com>
Cc: linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E9B98F2.9050407@shealevy.com>
References: <4E9B98F2.9050407@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Mon, 17 Oct 2011 23:39:11 -0400
Message-ID: <1318909151.5538.160.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 22:54 -0400, Shea Levy wrote:

> Where can I find the module-init-tools development repository? The url 
> given in [0] gives a "No such project" from git.kernel.org

Yea. There was a security compromise on kernel.org recently. The
releases of module-init-tools were actually some of the first to be put
back because I had personally signed them (as opposed to allowing the
kernel.org key to be used) but the git repo won't be up for another day
or two. I've been talking to the admin involved, so it'll be rsn.

Jon.


