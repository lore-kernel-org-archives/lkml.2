Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1CKId4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:33:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60452 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1CKIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EjreNyrTBjJFjt7PGOSJATXs7QRnHcO6R1bSiIdZ5QdMaQVuFXOk3w/SkpZZ2qv56t
         GIpbuGWQSpeQ5I91ypEVACFQ/mBapHiMvxpNtcdj89E9+Gd9VL7ZfloDm3/jsdysOnlv
         +V79oeI5jTU4ryDUm4tiGDJXYxsIUG8gEqvyA=
Date: Fri, 11 Mar 2011 09:33:51 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110311083351.GD13038@htj.dyndns.org>
References: <4D6E91EC.6040906@kernel.org>
 <20110302190208.GD28266@mtj.dyndns.org>
 <4D6E9541.2040201@kernel.org>
 <20110302191338.GE28266@mtj.dyndns.org>
 <4D6EA975.8070200@kernel.org>
 <20110302205704.GF28266@mtj.dyndns.org>
 <4D6EB335.8000306@kernel.org>
 <20110303061711.GG28266@mtj.dyndns.org>
 <4D791C9F.1010500@kernel.org>
 <20110311082938.GC13038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311082938.GC13038@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:29:38AM +0100, Tejun Heo wrote:
> Also, I don't think your patch is correct.  Even if there is phys_dist
                                                              ^
							      no
> table, emu distance tables should be built because emulated nids don't
> map to physical nids one to one.  ie. Two different emulated nids can
> share a physical node and the distance table should explicitly reflect
> that.

-- 
tejun
