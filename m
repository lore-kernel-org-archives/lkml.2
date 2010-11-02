Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0KBO3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:29:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40238 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab0KBO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sjpYw9wkWpVvgFIYfGRcKFG0zzkwU7D7Uz7R2RZtxm+PzwpY6VV3JjtiVVFPdU+sr1
         6MGXDKdva8RwESWA6r3k7arYLFS/tKaiVe4boc1RiXCC++oE97H9WWkrxtyMM4oEHOYc
         +WehBgR/cAS/adSUL2lD0xdlsT3cOxP1ga0lI=
Subject: Re: [PATCH]oom-kill: direct hardware access processes should get
 bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.DEB.2.00.1011012008160.9383@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain>
	 <alpine.DEB.2.00.1011012008160.9383@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 22:24:54 +0800
Message-ID: <1288707894.19865.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Which applications are you referring to that cannot gracefully exit if 
> killed?

like Xorg server, if xorg server be killed, the gnome desktop will be
crashed.


> 
> CAP_SYS_RAWIO had a much more dramatic impact in the previous heuristic to 
> such a point that it would often allow memory hogging tasks to elude the 
> oom killer at the expense of innocent tasks.  I'm not sure this is the 
> best way to go.

is it some experiments for demonstration the  CAP_SYS_RAWIO will elude
the oom killer?




