Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AXM2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:28:01 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57940 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1AXM2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:28:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=NHk2Z5Z+0kdLm7v/3F1Jhg564GzYu2H37jjHOmjJhD/5uS8wFeXj1jNHW7Mj1BVI+a
         B1MW+MJcn61+5sQ4KqTQhRpNZn9iyo6iVE5yRR3lDiJtCER2/5FBWpI67TlGrr894++a
         lHSYbi6fOkk2rHnXTBYe/QPkNfRXIAkwiE1Hw=
Date: Mon, 24 Jan 2011 10:27:54 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110124122754.GA5932@ghostprotocols.net>
References: <20110120093246.GA8031@hera.kernel.org>
 <20110120114719.GD23661@elte.hu>
 <4D385866.3060405@kernel.org>
 <20110120172218.GB13482@ghostprotocols.net>
 <20110121085721.GD2994@hpt.nay.redhat.com>
 <20110121132011.GA15066@ghostprotocols.net>
 <20110124025304.GB4694@hpt.nay.redhat.com>
 <20110124041520.GC4694@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124041520.GC4694@hpt.nay.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 24, 2011 at 12:15:20PM +0800, Han Pingtian escreveu:
> On Mon, Jan 24, 2011 at 10:53:04AM +0800, Han Pingtian wrote:
> > On Fri, Jan 21, 2011 at 11:20:11AM -0200, Arnaldo Carvalho de Melo wrote:
> > > Han, if you can after the patch make sure it builds in an RHEL4 machine,
> > > that would be great,
> > OK, I'll test perf/urgent on RHEL4 environments.
> > > 
> I have tested on RHEL4, the building works fine.

Thanks a lot for testing,

- Arnaldo
