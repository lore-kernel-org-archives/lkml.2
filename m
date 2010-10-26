Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab0JZOwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:52:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51455 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0JZOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=P4MU06xB8+K15ijLgvsicFl34ke7Z4wQyEUMplOD/Cuh65aj2+PMNMnuls2OJhgfro
         et89w+1RBEOFiWxv1rPpYEOqMN0zMsdCt7NP75LohQ9EoPkDd7s43doKn687g3CfIlIP
         fnR8qZNpUFXCA1H9/NHBlEnnMZ1vvIElm3xiU=
Date: Tue, 26 Oct 2010 12:52:28 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH] perf: Remove newline character from perror() argument
Message-ID: <20101026145228.GA26745@ghostprotocols.net>
References: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
 <20100828155251.GP2973@ghostprotocols.net>
 <20101026143448.GA21107@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026143448.GA21107@console-pimps.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 26, 2010 at 03:34:48PM +0100, Matt Fleming escreveu:
> On Sat, Aug 28, 2010 at 12:52:51PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Sat, Aug 28, 2010 at 04:46:19PM +0100, Matt Fleming escreveu:
> > > If we include a newline character in the string argument to perror()
> > > then the output will be split across two lines like so,
> > > 
> > >     Unable to read perf file descriptor
> > >     : No space left on device
> > > 
> > > Deleting the newline character prints a much more readable error,
> > > 
> > >     Unable to read perf file descriptor: No space left on device
> > 
> > Thanks, applying.
> > 
> > - Arnaldo
> 
> Hi Arnaldo,
> 
> Whatever happend to this? I can't see it in any of the perf trees.

Checking... Will fold it in if I missed it, thanks for the reminder!

- Arnaldo
