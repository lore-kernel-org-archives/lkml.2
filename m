Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0CYVDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:03:16 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:58181 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0CYVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:03:12 -0400
Date: Thu, 25 Mar 2010 16:03:04 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Potential stack overflow
In-Reply-To: <4BABB982.7070906@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1003251602300.9791@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241414270.14329@router.home>  <1269458528.2849.2.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241443520.14329@router.home>  <1269464591.2849.15.camel@edumazet-laptop> 
 <alpine.DEB.2.00.1003241608270.16858@router.home>  <alpine.DEB.2.00.1003241613350.16858@router.home> <1269465947.2849.21.camel@edumazet-laptop> <4BABB982.7070906@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Pekka Enberg wrote:

> Christoph, does this look OK to you? I think Eric has all your later additions
> and kfree() fixlets here.

Yes just dont know how to add an Ack given that there is already a
signoff.
