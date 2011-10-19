Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1JSUWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:22:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5492 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1JSUWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:22:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jdP2uYKFpiFUjNm1Q5wOApWv2zcME52/UK5DilC+XpbPw13h8BWtkC8mymbuSkjdZ
	v1d6wUfbZAkXT/Av+QWRw==
Date: Wed, 19 Oct 2011 13:21:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Antonio Ospite <ospite@studenti.unina.it>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
cc: "Tomas M." <tmezzadra@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: kernel OOPS when releasing usb webcam (random)
In-Reply-To: <alpine.DEB.2.00.1110181332320.2639@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1110191321200.2892@chino.kir.corp.google.com>
References: <4E9CB0C2.3030902@gmail.com> <alpine.DEB.2.00.1110171703210.13515@chino.kir.corp.google.com> <20111018104054.07aa2bcf462c0268a23c0139@studenti.unina.it> <alpine.DEB.2.00.1110181332320.2639@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, David Rientjes wrote:

> Guennadi or Mauro, how is this going to Linus?  It sounds like 3.1 
> material since we've received at least a couple of reports of this in the 
> past week.
> 

This fix is now in Linus' tree at e58fced201ad ("[media] videodev: fix a 
NULL pointer dereference in v4l2_device_release()") for 3.1.
