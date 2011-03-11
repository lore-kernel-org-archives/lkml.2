Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1CKK6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:58:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55861 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1CKK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x/P2NH/xQTjEhsc9xZ/QArDoD0VpR8JAyfTnINjxdylCPBXBLdN52BmLQyCX7MHgoi
         pEjEYz95j5K0BSFyU0NopTErmqq+e6KZKYSt09Esx6OSGRJNI5vda9qKgsNYFtuvzJ/G
         2Pe1huZe4mPwKgm4Hibz7GJypsZPoSt6J/RlM=
Date: Fri, 11 Mar 2011 11:51:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Liao <phyomh@gmail.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110311105118.GA1826@nowhere>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
 <20110307180619.GG1873@nowhere>
 <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
 <20110310024355.GG2533@nowhere>
 <20110310064816.GF9289@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310064816.GF9289@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 07:48:16AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > But your idea of turning the callee into the caller would show us a very global 
> > profiling. With reverse callchains it can be a very nice overview of the big 
> > picture.
> 
> Very much agreed - i think that matches the sysprof display structure as well, 
> right?

Yeah indeed, IIRC.
 
> This could then be propagated not just into perf report but perf top --tui as well.

Probably yeah. Are callchains already supported by perf top?
