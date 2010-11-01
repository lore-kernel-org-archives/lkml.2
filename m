Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0KAMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:52:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57011 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0KAMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=k8XAXgB4VEq7LUzmVb2VNStccGfUNfXf4LJbN2ax460VrFDnfTQQO9XQJOoOMthojm
         LosRqXvTy4Fjf3CoUZSleb9wmTe9y6K2VneWzWndPzDKJ+EhRt/OpXVO8+O3T2TsCMD+
         2gNB9EaTY85W++32KWMXHBlRYovFpA28PTkKw=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Kconfig option for default swappiness
In-Reply-To: <20101101124322.GG840@cmpxchg.org>
References: <1288548508-22070-1-git-send-email-bgamari.foss@gmail.com> <20101101124322.GG840@cmpxchg.org>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Nov 2010 08:52:30 -0400
Message-ID: <8739rlnr3l.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010 08:43:22 -0400, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Sun, Oct 31, 2010 at 02:08:28PM -0400, Ben Gamari wrote:
> > This will allow distributions to tune this important vm parameter in a more
> > self-contained manner.
> 
> What's wrong with sticking
> 
> 	vm.swappiness = <your value>
> 
> into the shipped /etc/sysctl.conf?

Ubuntu ships different kernels for desktop and server usage. From a
packaging standpoint it would be much nicer to have this set in the
kernel configuration. If we were to throw the setting /etc/sysctl.conf
the kernel would depend upon the package containing sysctl(8)
(procps). We'd rather avoid this and keep the default kernel
configuration in one place. This was just an RFC though; let me know if
you think this is totally insane.

- Ben
