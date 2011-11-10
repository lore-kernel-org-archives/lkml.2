Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1KJFms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:42:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38487 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1KJFmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 00:42:47 -0500
Date: Wed, 9 Nov 2011 21:42:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] [2.6.32-stable] mm: avoid null pointer access in vm_struct
 via /proc/vmallocinfo
In-Reply-To: <20111110044801.GA24277@kroah.com>
Message-ID: <alpine.DEB.2.00.1111092141470.549@chino.kir.corp.google.com>
References: <20111107182439.GA5806@kroah.com> <20111110043716.11274.32615.stgit@ltc219.sdl.hitachi.co.jp> <20111110044801.GA24277@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011, Greg KH wrote:

> > This patch is the backport version of the patch which solves a null
> > pointer access in vm_struct via /proc/vmallocinfo.
> 
> What is the commit id of the version of this patch in Linus's tree?
> 

The version in Linus' tree is f5252e009d5b87071a919221e4f6624184005368, 
you also queued it for 3.0 and 3.1 stable.
